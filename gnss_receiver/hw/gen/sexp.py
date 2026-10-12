"""S-выражения KiCad: разбор и сериализация.

Узел — список [голова, аргументы...]. Строковые литералы хранятся как экземпляры класса Q
(чтобы при записи сохранить кавычки), прочие атомы — как str.
"""


class Q(str):
    """Строка в кавычках."""


def tokenize(s):
    i, n = 0, len(s)
    while i < n:
        c = s[i]
        if c in "()":
            yield c
            i += 1
        elif c.isspace():
            i += 1
        elif c == '"':
            j, buf = i + 1, []
            while s[j] != '"':
                if s[j] == "\\":
                    nxt = s[j + 1]
                    buf.append({"n": "\n", "t": "\t", "\\": "\\", '"': '"'}.get(nxt, nxt))
                    j += 2
                else:
                    buf.append(s[j])
                    j += 1
            yield Q("".join(buf))
            i = j + 1
        else:
            j = i
            while j < n and not s[j].isspace() and s[j] not in "()":
                j += 1
            yield s[i:j]
            i = j


def loads(s):
    stack = [[]]
    for t in tokenize(s):
        if t == "(":
            stack.append([])
        elif t == ")":
            x = stack.pop()
            stack[-1].append(x)
        else:
            stack[-1].append(t)
    return stack[0][0]


def _atom(a):
    if isinstance(a, Q):
        return '"' + a.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'
    if isinstance(a, float):
        r = f"{a:.4f}".rstrip("0").rstrip(".")
        return "0" if r == "-0" else r
    return str(a)


def dumps(node, indent=0):
    """Сериализация с переносом строк для вложенных списков (формат, похожий на KiCad)."""
    if not isinstance(node, list):
        return _atom(node)
    simple = all(not isinstance(x, list) for x in node)
    if simple:
        return "(" + " ".join(_atom(x) for x in node) + ")"
    pad = "  " * (indent + 1)
    parts = []
    head = []
    for x in node:
        if isinstance(x, list):
            break
        head.append(_atom(x))
    out = "(" + " ".join(head)
    for x in node[len(head):]:
        if isinstance(x, list):
            parts.append("\n" + pad + dumps(x, indent + 1))
        else:
            parts.append(" " + _atom(x))
    return out + "".join(parts) + "\n" + "  " * indent + ")"


def find(node, key):
    return [c for c in node if isinstance(c, list) and c and c[0] == key]


def first(node, key, default=None):
    r = find(node, key)
    return r[0] if r else default


def remove(node, key):
    node[:] = [c for c in node if not (isinstance(c, list) and c and c[0] == key)]
