lines = []
while True:
    try:
        line = input()
        if not line:
            break
        lines.append(line)
    except EOFError:
        break
for i,x in enumerate(lines) :
    lines[i] = x.strip()

ans = {}
for x in lines:
    a, b = x.split("-")
    ans[a] = b

ans = sorted(ans.items(), key=lambda item: item[1], reverse=True)

print(ans[0][0])