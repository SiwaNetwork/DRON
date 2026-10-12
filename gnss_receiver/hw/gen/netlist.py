"""Модель схемы: листы, компоненты, цепи. Проверка электрических связей (собственный ERC)."""
from collections import defaultdict
from dataclasses import dataclass, field


@dataclass
class Comp:
    pd: object                 # parts.PartDef
    conns: dict                # номер вывода -> имя цепи (None — вывод не подключён, NC)
    sheet: str
    block: str
    ref: str = ""
    dnp: bool = False
    note: str = ""
    order: int = 0
    unit_sheets: dict = field(default_factory=dict)  # для многочастных ИС: номер части -> лист


class Sheet:
    def __init__(self, design, sid, title, paper="A3"):
        self.d, self.sid, self.title, self.paper = design, sid, title, paper
        self.comps = []
        self.blocks = []       # порядок блоков
        self.notes = []        # текстовые примечания на листе

    def add(self, pd, conns, block=None, dnp=False, note="", units=None):
        """conns: {имя_вывода|#номер: цепь|None}. Одноимённые выводы подключаются все."""
        block = block or f"b{len(self.blocks)}"
        if block not in self.blocks:
            self.blocks.append(block)
        pinmap = {}
        for key, net in conns.items():
            nums = pd.pins.get(key) if not key.startswith("#") else [key[1:]]
            if not nums and ("#" + key) in pd.pins:
                nums = [key]
            if not nums:
                raise KeyError(f"{pd.pn}: нет вывода '{key}'")
            for n in nums:
                if n in pinmap and pinmap[n] is not None and net is not None and pinmap[n] != net:
                    raise ValueError(f"{pd.pn}: вывод {n} уже подключён к {pinmap[n]}, а не {net}")
                if net is not None or n not in pinmap:
                    pinmap[n] = net
        c = Comp(pd, pinmap, self.sid, block, dnp=dnp, note=note, order=len(self.d.comps))
        if units:
            c.unit_sheets = units
            for sh in self.d.sheets:
                if sh.sid in units.values() and block not in sh.blocks:
                    sh.blocks.append(block)
        self.comps.append(c)
        self.d.comps.append(c)
        return c


class Design:
    def __init__(self, name):
        self.name = name
        self.sheets = []
        self.comps = []
        self.power_nets = set()
        self.gnd = "GND"

    def sheet(self, sid, title, paper="A3"):
        s = Sheet(self, sid, title, paper)
        self.sheets.append(s)
        return s

    def nets(self):
        n = defaultdict(list)
        for c in self.comps:
            for pin, net in c.conns.items():
                if net:
                    n[net].append((c, pin))
        return n

    def net_sheets(self):
        ns = defaultdict(set)
        for c in self.comps:
            for pin, net in c.conns.items():
                if net:
                    ns[net].add(self._pin_sheet(c, pin))
        return ns

    def _pin_sheet(self, c, pin):
        if not c.unit_sheets:
            return c.sheet
        u = c.pd.pin_unit.get(pin, 1)
        return c.unit_sheets.get(u, c.sheet)

    def erc(self):
        """Возвращает (ошибки, предупреждения)."""
        errs, warns = [], []
        all_pins = {}
        for c in self.comps:
            declared = set(c.pd.all_pins)
            missing = declared - set(c.conns)
            if missing:
                errs.append(f"{c.ref or c.pd.pn}: не заданы выводы {sorted(missing)[:12]}")
            extra = set(c.conns) - declared
            if extra:
                errs.append(f"{c.ref or c.pd.pn}: неизвестные выводы {sorted(extra)}")
        for net, pins in self.nets().items():
            if len(pins) < 2:
                c, p = pins[0]
                errs.append(f"Цепь {net}: единственное подключение {c.ref}.{p}")
            types = [c.pd.pin_type.get(p, "passive") for c, p in pins]
            drivers = [t for t in types if t in ("output", "power_out")]
            if len(drivers) > 1 and net not in self.power_nets and net != self.gnd:
                warns.append(f"Цепь {net}: несколько выходов ({len(drivers)})")
            if net in self.power_nets or net == self.gnd:
                continue
            ins = [t for t in types if t == "input"]
            if ins and not drivers and all(t in ("input",) for t in types):
                warns.append(f"Цепь {net}: только входы")
        return errs, warns
