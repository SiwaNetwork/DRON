/* МГП-8: навигационное решение — взвешенный МНК по псевдодальностям (координаты + смещения шкал
 * по системам), скорость и дрейф часов — по доплеровским измерениям. Поправки: часы КА (вкл.
 * релятивистскую), вращение Земли за время распространения, тропосфера (модель Саастамойнена со
 * стандартной атмосферой), ионосфера (модель Клобучара, по параметрам из навигационного сообщения). */
#include <math.h>
#include <string.h>
#include "pvt.h"

#define WGS_A   6378137.0
#define WGS_F   (1.0 / 298.257223563)
#define OMGE    7.2921151467e-5

void pvt_default_cfg(pvt_cfg_t *c)
{
    memset(c, 0, sizeof(*c));
    c->el_mask = 10.0 * GPI / 180;
    c->trop = 1;
    c->iono = 1;
    c->tgd = 1;
}

void llh2ecef(double lat, double lon, double h, double *r)
{
    double e2 = WGS_F * (2 - WGS_F), s = sin(lat), N = WGS_A / sqrt(1 - e2 * s * s);
    r[0] = (N + h) * cos(lat) * cos(lon);
    r[1] = (N + h) * cos(lat) * sin(lon);
    r[2] = (N * (1 - e2) + h) * s;
}

void ecef2llh(const double *r, double *lat, double *lon, double *h)
{
    double e2 = WGS_F * (2 - WGS_F), p = hypot(r[0], r[1]), z = r[2], zk = 0, v = WGS_A;
    for (int i = 0; i < 20 && fabs(z - zk) >= 1e-4; i++) {
        zk = z;
        double s = z / sqrt(p * p + z * z);
        v = WGS_A / sqrt(1 - e2 * s * s);
        z = r[2] + v * e2 * s;
    }
    *lat = p > 1e-12 ? atan(z / p) : (r[2] > 0 ? GPI / 2 : -GPI / 2);
    *lon = p > 1e-12 ? atan2(r[1], r[0]) : 0;
    *h = sqrt(p * p + z * z) - v;
}

static void azel(const double *rr, double lat, double lon, const double *rs, double *az, double *el)
{
    double d[3] = {rs[0] - rr[0], rs[1] - rr[1], rs[2] - rr[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
    double sl = sin(lat), cl = cos(lat), so = sin(lon), co = cos(lon);
    double e = (-so * d[0] + co * d[1]) / rho;
    double n = (-sl * co * d[0] - sl * so * d[1] + cl * d[2]) / rho;
    double u = (cl * co * d[0] + cl * so * d[1] + sl * d[2]) / rho;
    *az = atan2(e, n);
    *el = asin(u);
}

/* тропосфера: Саастамойнен, стандартная атмосфера, влажность 70 % */
static double trop(double h, double el)
{
    if (h < -100 || h > 1e4 || el <= 0) return 0;
    double hh = h < 0 ? 0 : h;
    double p = 1013.25 * pow(1 - 2.2557e-5 * hh, 5.2568), T = 15.0 - 6.5e-3 * hh + 273.16;
    double e = 6.108 * 0.7 * exp((17.15 * T - 4684.0) / (T - 38.45));
    double z = GPI / 2 - el;
    return 0.0022768 * (p + (1255.0 / T + 0.05) * e) / cos(z);
}

/* ионосфера: модель Клобучара (IS-GPS-200, 20.3.3.5.2.5), задержка на L1, м */
static double klobuchar(const double *ion, double t, double lat, double lon, double az, double el)
{
    double E = el / GPI, phi_u = lat / GPI, lam_u = lon / GPI;
    double psi = 0.0137 / (E + 0.11) - 0.022;
    double phi_i = phi_u + psi * cos(az);
    if (phi_i > 0.416) phi_i = 0.416;
    if (phi_i < -0.416) phi_i = -0.416;
    double lam_i = lam_u + psi * sin(az) / cos(phi_i * GPI);
    double phi_m = phi_i + 0.064 * cos((lam_i - 1.617) * GPI);
    double tt = fmod(43200 * lam_i + t, 86400);
    if (tt < 0) tt += 86400;
    double F = 1 + 16 * pow(0.53 - E, 3);
    double amp = ion[0] + phi_m * (ion[1] + phi_m * (ion[2] + phi_m * ion[3]));
    double per = ion[4] + phi_m * (ion[5] + phi_m * (ion[6] + phi_m * ion[7]));
    if (amp < 0) amp = 0;
    if (per < 72000) per = 72000;
    double x = 2 * GPI * (tt - 50400) / per;
    double d = fabs(x) < 1.57 ? F * (5e-9 + amp * (1 - x * x / 2 + x * x * x * x / 24)) : F * 5e-9;
    return CLIGHT * d;
}

/* решение нормальных уравнений (Холецкий), n ≤ 8; N — n×n, b — n; возвращает 0 при вырождении */
static int solve(double *N, double *b, int n, double *Q)
{
    double L[64] = {0};
    for (int i = 0; i < n; i++)
        for (int j = 0; j <= i; j++) {
            double s = N[i * n + j];
            for (int k = 0; k < j; k++) s -= L[i * n + k] * L[j * n + k];
            if (i == j) { if (s <= 1e-20) return 0; L[i * n + i] = sqrt(s); }
            else L[i * n + j] = s / L[j * n + j];
        }
    double y[8];
    for (int i = 0; i < n; i++) { double s = b[i]; for (int k = 0; k < i; k++) s -= L[i * n + k] * y[k]; y[i] = s / L[i * n + i]; }
    for (int i = n - 1; i >= 0; i--) { double s = y[i]; for (int k = i + 1; k < n; k++) s -= L[k * n + i] * b[k]; b[i] = s / L[i * n + i]; }
    if (Q)                                               /* Q = N^-1 по столбцам */
        for (int c = 0; c < n; c++) {
            double e[8] = {0}, z[8];
            e[c] = 1;
            for (int i = 0; i < n; i++) { double s = e[i]; for (int k = 0; k < i; k++) s -= L[i * n + k] * z[k]; z[i] = s / L[i * n + i]; }
            for (int i = n - 1; i >= 0; i--) { double s = z[i]; for (int k = i + 1; k < n; k++) s -= L[k * n + i] * e[k]; e[i] = s / L[i * n + i]; }
            for (int i = 0; i < n; i++) Q[i * n + c] = e[i];
        }
    return 1;
}

int pvt_solve(obs_t *obs, int n, double t_rx, const pvt_cfg_t *cfg, sol_t *sol)
{
    double x[3] = {sol->pos[0], sol->pos[1], sol->pos[2]};
    int sysidx[SYS_N], nsys = 0;
    for (int s = 0; s < SYS_N; s++) sysidx[s] = -1;
    for (int i = 0; i < n; i++) if (obs[i].eph && sysidx[obs[i].sys] < 0) sysidx[obs[i].sys] = nsys++;
    int nu = 3 + nsys;
    double clk[SYS_N] = {0}, rs[PVT_MAXOBS][3], dts[PVT_MAXOBS];
    double Q[64];
    sol->ok = 0;
    for (int it = 0; it < 12; it++) {
        double N[64] = {0}, b[8] = {0}, lat, lon, h, ss = 0;
        int m = 0;
        ecef2llh(x, &lat, &lon, &h);
        int have_pos = sqrt(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]) > 6.0e6;
        for (int i = 0; i < n; i++) {
            obs_t *o = &obs[i];
            o->used = 0;
            if (!o->eph || o->pr <= 0) continue;
            int si = sysidx[o->sys];
            /* время излучения и координаты КА с поправкой за вращение Земли */
            /* t_rx — показание часов приёмника: момент излучения по шкале системы = t_rx − pr/c */
            double tt = t_rx - o->pr / CLIGHT, dt0, r0[3];
            if (!eph_satpos(o->eph, tt, r0, &dt0, NULL, NULL)) continue;
            tt -= dt0;
            if (!eph_satpos(o->eph, tt, rs[i], &dts[i], NULL, NULL)) continue;
            /* GPS: часы КА в эфемеридах отнесены к ионосферно-свободной комбинации; для ПД на
             * одной частоте fc — Δt − TGD·(f1/fc)² (IS-GPS-200, п. 20.3.3.3.3.2). Galileo E1
             * (часы I/NAV — по E1, E5b): Δt − BGD(E1, E5b); BeiDou B1I (часы — по B3I): Δt − TGD1 */
            if (cfg->tgd && o->sys == SYS_GPS && !o->iono_free) {
                double f = sig_carrier(SIG_L1CA, 0) / (o->fc > 0 ? o->fc : sig_carrier(SIG_L1CA, 0));
                dts[i] -= o->eph->tgd * f * f;
            } else if (cfg->tgd && (o->sys == SYS_GAL || o->sys == SYS_BDS) && !o->iono_free)
                dts[i] -= o->eph->tgd;
            double d[3] = {rs[i][0] - x[0], rs[i][1] - x[1], rs[i][2] - x[2]};
            double rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
            double th = OMGE * rho / CLIGHT, xs = rs[i][0] * cos(th) + rs[i][1] * sin(th);
            double ys = -rs[i][0] * sin(th) + rs[i][1] * cos(th);
            double rsr[3] = {xs, ys, rs[i][2]};
            d[0] = rsr[0] - x[0]; d[1] = rsr[1] - x[1]; d[2] = rsr[2] - x[2];
            rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
            double corr = 0, w = 1;
            o->el = GPI / 2; o->az = 0;
            if (have_pos) {
                azel(x, lat, lon, rsr, &o->az, &o->el);
                if (it > 1 && o->el < cfg->el_mask) continue;
                if (cfg->trop) corr += trop(h, o->el);
                if (cfg->iono && !o->iono_free) {
                    double di = klobuchar(cfg->ion, t_rx, lat, lon, o->az, o->el);
                    double f = sig_carrier(SIG_L1CA, 0) / (o->fc > 0 ? o->fc : sig_carrier(SIG_L1CA, 0));
                    corr += di * f * f;
                }
                double se = sin(o->el > 0.05 ? o->el : 0.05);
                w = se * se;
            }
            double res = o->pr - (rho + clk[o->sys] - CLIGHT * dts[i] + corr);
            double H[8] = {-d[0] / rho, -d[1] / rho, -d[2] / rho, 0, 0, 0, 0, 0};
            H[3 + si] = 1;
            for (int a = 0; a < nu; a++) {
                b[a] += w * H[a] * res;
                for (int c = 0; c < nu; c++) N[a * nu + c] += w * H[a] * H[c];
            }
            o->res = res;
            o->used = 1;
            ss += res * res;
            m++;
        }
        /* система без измерений (все ниже маски) — слабая связь, чтобы матрица не вырождалась */
        for (int sy = 0; sy < SYS_N; sy++)
            if (sysidx[sy] >= 0 && N[(3 + sysidx[sy]) * nu + 3 + sysidx[sy]] == 0) N[(3 + sysidx[sy]) * nu + 3 + sysidx[sy]] = 1e-6;
        if (m < 4 || !solve(N, b, nu, Q)) return 0;
        for (int k = 0; k < 3; k++) x[k] += b[k];
        for (int s = 0; s < SYS_N; s++) if (sysidx[s] >= 0) clk[s] += b[3 + sysidx[s]];
        sol->nsat = m;
        sol->rms = sqrt(ss / m);
        if (sqrt(b[0] * b[0] + b[1] * b[1] + b[2] * b[2]) < 1e-4) { sol->ok = 1; break; }
    }
    if (!sol->ok) return 0;
    memcpy(sol->pos, x, sizeof(x));
    memcpy(sol->clk, clk, sizeof(clk));
    sol->nsys = nsys;
    ecef2llh(x, &sol->lat, &sol->lon, &sol->h);
    /* DOP: Q (без весов) в осях ENU */
    {
        double N[64] = {0}, b[8] = {0}, Qu[64];
        for (int i = 0; i < n; i++) {
            if (!obs[i].used) continue;
            double ce = cos(obs[i].el);
            double H[8] = {ce * sin(obs[i].az), ce * cos(obs[i].az), sin(obs[i].el), 0, 0, 0, 0, 0};
            H[3 + sysidx[obs[i].sys]] = 1;
            for (int a = 0; a < nu; a++) for (int c = 0; c < nu; c++) N[a * nu + c] += H[a] * H[c];
        }
        if (solve(N, b, nu, Qu)) {
            sol->hdop = sqrt(Qu[0] + Qu[nu + 1]);
            sol->vdop = sqrt(Qu[2 * nu + 2]);
            sol->pdop = sqrt(Qu[0] + Qu[nu + 1] + Qu[2 * nu + 2]);
            sol->tdop = sqrt(Qu[3 * nu + 3]);
            sol->gdop = sqrt(sol->pdop * sol->pdop + sol->tdop * sol->tdop);
            sol->q_e = Qu[0]; sol->q_n = Qu[nu + 1]; sol->q_u = Qu[2 * nu + 2]; sol->q_en = Qu[1];
        }
    }
    /* скорость и дрейф часов по доплеру */
    {
        double N[16] = {0}, b[4] = {0};
        int m = 0;
        for (int i = 0; i < n; i++) {
            obs_t *o = &obs[i];
            if (!o->used || o->dop == 0) continue;
            double tt = t_rx - o->pr / CLIGHT, r[3], vs[3], d0, dd;
            if (!eph_satpos(o->eph, tt, r, &d0, vs, &dd)) continue;
            double d[3] = {r[0] - x[0], r[1] - x[1], r[2] - x[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
            double e[3] = {d[0] / rho, d[1] / rho, d[2] / rho};
            double lam = CLIGHT / o->fc;
            /* доплер: f_d = −(ṙ_sat − ṙ_rx)·e/λ − ḃ/λ + ...  ⇒  −λ·f_d − vs·e − c·ddts = −v·e + ḃ */
            double y = -lam * o->dop - (vs[0] * e[0] + vs[1] * e[1] + vs[2] * e[2]) + CLIGHT * dd;
            double H[4] = {-e[0], -e[1], -e[2], 1};
            for (int a = 0; a < 4; a++) { b[a] += H[a] * y; for (int c = 0; c < 4; c++) N[a * 4 + c] += H[a] * H[c]; }
            m++;
        }
        if (m >= 4 && solve(N, b, 4, NULL)) {
            sol->vel[0] = b[0]; sol->vel[1] = b[1]; sol->vel[2] = b[2]; sol->clkd = b[3];
        }
    }
    /* GPST — по часам GPS; без КА GPS — по первой системе решения (её шкала приведена к GPST:
     * ГЛОНАСС — с поправкой UTC, BDT + 14 с, GST — без GGTO; расхождение — единицы-десятки нс) */
    int sref = SYS_GPS;
    if (sysidx[SYS_GPS] < 0)
        for (int s = 0; s < SYS_N; s++) if (sysidx[s] == 0) sref = s;
    sol->t_rx = t_rx - clk[sref] / CLIGHT;
    return 1;
}
