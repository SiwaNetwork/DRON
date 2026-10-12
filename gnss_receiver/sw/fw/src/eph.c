/* МГП-8: координаты КА по бортовым эфемеридам (IS-GPS-200, Galileo OS SIS ICD, BDS-SIS-ICD,
 * ИКД ГЛОНАСС ред. 5.1). Перенос эталона sim/gnss_orbits.py. */
#include <math.h>
#include <stddef.h>
#include "gnss.h"
#include "eph.h"

static const double MU[SYS_N] = {3.986005e14, 3.9860044e14, 3.986004418e14, 3.986004418e14, 3.986005e14,
                                 3.986005e14, 3.986005e14};
static const double OMGE[SYS_N] = {7.2921151467e-5, 7.292115e-5, 7.2921151467e-5, 7.2921150e-5, 7.2921151467e-5,
                                   7.2921151467e-5, 7.2921151467e-5};
static const double VALID[SYS_N] = {7200, 1800, 4 * 3600, 3600, 7200, 7200, 7200};

double eph_tdiff(double t1, double t0)
{
    double d = t1 - t0;
    if (d > 302400) d -= 604800;
    if (d < -302400) d += 604800;
    return d;
}

static int bds_geo(int prn) { return prn <= 5 || prn >= 59; }

static int kepler(const eph_t *e, double t, double rs[3], double *dts)
{
    double mu = MU[e->sys], we = OMGE[e->sys];
    double tk = eph_tdiff(t, e->toe);
    double a = e->sqrtA * e->sqrtA;
    double n = sqrt(mu / (a * a * a)) + e->dn;
    double M = e->M0 + n * tk, E = M;
    for (int i = 0; i < 30; i++) {
        double Ek = E;
        E = M + e->e * sin(E);
        if (fabs(E - Ek) < 1e-14) break;
    }
    double nu = atan2(sqrt(1 - e->e * e->e) * sin(E), cos(E) - e->e);
    double phi = nu + e->omg, s2 = sin(2 * phi), c2 = cos(2 * phi);
    double u = phi + e->cus * s2 + e->cuc * c2;
    double r = a * (1 - e->e * cos(E)) + e->crs * s2 + e->crc * c2;
    double inc = e->i0 + e->cis * s2 + e->cic * c2 + e->idot * tk;
    double xp = r * cos(u), yp = r * sin(u);
    /* время эфемерид в собственной шкале системы (для члена Ω·toe) */
    double toe_sys = e->sys == SYS_BDS ? fmod(e->toe - GPST_BDT + 604800, 604800) : e->toe;
    if (e->sys == SYS_BDS && bds_geo(e->prn)) {
        double om = e->OMG0 + e->OMGd * tk - we * toe_sys;
        double xg = xp * cos(om) - yp * cos(inc) * sin(om);
        double yg = xp * sin(om) + yp * cos(inc) * cos(om);
        double zg = yp * sin(inc);
        double f5 = -5.0 * GPI / 180, ang = we * tk;
        double x1 = xg, y1 = yg * cos(f5) + zg * sin(f5), z1 = -yg * sin(f5) + zg * cos(f5);
        rs[0] = x1 * cos(ang) + y1 * sin(ang);
        rs[1] = -x1 * sin(ang) + y1 * cos(ang);
        rs[2] = z1;
    } else {
        double om = e->OMG0 + (e->OMGd - we) * tk - we * toe_sys;
        rs[0] = xp * cos(om) - yp * cos(inc) * sin(om);
        rs[1] = xp * sin(om) + yp * cos(inc) * cos(om);
        rs[2] = yp * sin(inc);
    }
    double tc = eph_tdiff(t, e->toc);
    *dts = e->af0 + e->af1 * tc + e->af2 * tc * tc - 4.442807633e-10 * e->e * e->sqrtA * sin(E);
    return 1;
}

/* ГЛОНАСС: уравнения движения в ПЗ-90 (ИКД, прил. А) */
static void glo_deriv(const double *s, const double *acc, double *d)
{
    const double mu = 398600.4418e9, ae = 6378136.0, j2 = 1.08262575e-3, we = 7.292115e-5;
    double r2 = s[0] * s[0] + s[1] * s[1] + s[2] * s[2], r = sqrt(r2), r3 = r2 * r;
    double k = 1.5 * j2 * mu * ae * ae / (r2 * r3), zz = 5 * s[2] * s[2] / r2;
    d[0] = s[3]; d[1] = s[4]; d[2] = s[5];
    d[3] = -mu / r3 * s[0] - k * s[0] * (1 - zz) + we * we * s[0] + 2 * we * s[4] + acc[0];
    d[4] = -mu / r3 * s[1] - k * s[1] * (1 - zz) + we * we * s[1] - 2 * we * s[3] + acc[1];
    d[5] = -mu / r3 * s[2] - k * s[2] * (3 - zz) + acc[2];
}

static void rk4(double *s, const double *acc, double h)
{
    double k1[6], k2[6], k3[6], k4[6], t[6];
    glo_deriv(s, acc, k1);
    for (int i = 0; i < 6; i++) t[i] = s[i] + h / 2 * k1[i];
    glo_deriv(t, acc, k2);
    for (int i = 0; i < 6; i++) t[i] = s[i] + h / 2 * k2[i];
    glo_deriv(t, acc, k3);
    for (int i = 0; i < 6; i++) t[i] = s[i] + h * k3[i];
    glo_deriv(t, acc, k4);
    for (int i = 0; i < 6; i++) s[i] += h / 6 * (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]);
}

static int glonass(const eph_t *e, double t, double rs[3], double *dts)
{
    double s[6] = {e->pos[0], e->pos[1], e->pos[2], e->vel[0], e->vel[1], e->vel[2]};
    double dt = eph_tdiff(t, e->toc), h = dt >= 0 ? 60.0 : -60.0;
    int n = (int)(fabs(dt) / 60);
    for (int i = 0; i < n; i++) rk4(s, e->acc, h);
    double rem = dt - n * h;
    if (fabs(rem) > 1e-6) rk4(s, e->acc, rem);
    rs[0] = s[0]; rs[1] = s[1]; rs[2] = s[2];
    *dts = e->taun + e->gamn * dt;                  /* в RINEX хранится −τn */
    return 1;
}

static int pos1(const eph_t *e, double t, double rs[3], double *dts)
{
    if (!e || !e->valid) return 0;
    return e->sys == SYS_GLO ? glonass(e, t, rs, dts) : kepler(e, t, rs, dts);
}

int eph_satpos(const eph_t *e, double t, double rs[3], double *dts, double vs[3], double *ddts)
{
    double d0;
    if (!pos1(e, t, rs, &d0)) return 0;
    if (dts) *dts = d0;
    if (vs || ddts) {
        double r1[3], r2[3], d1, d2, h = 0.01;
        pos1(e, t - h, r1, &d1);
        pos1(e, t + h, r2, &d2);
        if (vs) for (int i = 0; i < 3; i++) vs[i] = (r2[i] - r1[i]) / (2 * h);
        if (ddts) *ddts = (d2 - d1) / (2 * h);
    }
    return 1;
}

const eph_t *eph_select(const eph_t *eph, int n, int sys, int prn, double t)
{
    const eph_t *best = NULL;
    double bd = 1e30;
    for (int i = 0; i < n; i++) {
        if (!eph[i].valid || eph[i].sys != sys || eph[i].prn != prn) continue;
        double d = fabs(eph_tdiff(t, eph[i].toc));
        if (d < bd) { bd = d; best = &eph[i]; }
    }
    return (best && bd <= VALID[sys]) ? best : NULL;
}
