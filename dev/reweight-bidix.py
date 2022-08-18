#!/usr/bin/env python3

TERMINATOR = " a=\"REWEIGHTERED\""

def reweight(ambiguities, outf):
    print()
    for i, ambig in enumerate(ambiguities):
        print(f"{i}. {ambig}")
    print("Give weights in floats (default 1.0):")
    for ambig in ambiguities:
        weight = input(ambig)
        if not weight:
            print(ambig.replace("<e", "<e" + TERMINATOR), file=outf)
        elif weight in ["q", "quit"]:
            print(ambig.replace("<e", "<e" + TERMINATOR), file=outf)
            return True
        else:
            print(ambig.replace("<e", "<e w=\"" + weight + "\"" +
                  TERMINATOR),
                  file=outf)
            ambiguities = []

def do_stuff(ambiguities, outf):
    quitting = False
    if ambiguities and len(ambiguities) > 1:
        quitting = reweight(ambiguities, outf)
    elif len(ambiguities) == 1:
        print(ambiguities[0].replace("<e", "<e" + TERMINATOR), file=outf)
    return quitting


def main():
    with open("apertium-fin-eng.fin-eng.dix", "r", encoding="utf-8") as inf, \
         open("apertium-fin-eng.fin-eng.dix.rew", "w", encoding="utf-8") as outf:
        ambiguities = []
        currentword = None
        quitting = False
        for line in inf:
            if quitting:
                do_stuff(ambiguities, outf)
                ambiguities = []
                print(line.rstrip("\n"), file=outf)
                continue
            elif "<e" not in line:
                do_stuff(ambiguities, outf)
                ambiguities = []
                print(line.rstrip("\n"), file=outf)
                continue
            elif TERMINATOR in line:
                do_stuff(ambiguities, outf)
                ambiguities = []
                print(line.rstrip("\n"), file=outf)
                continue
            elif "<l" in line:
                wstart = line.find(">", line.find("<l") + 2)
                wend = line.find("<", wstart)
                word = line[wstart:wend]
            elif "<i" in line:
                wstart = line.find(">", line.find("<i") + 2)
                wend = line.find("<", wstart)
                word = line[wstart:wend]
            else:
                print("error in line:", line)
            if word != currentword:
                quitting = do_stuff(ambiguities, outf)
                ambiguities = []
            ambiguities += [line.rstrip("\n")]
            currentword = word


if __name__ == "__main__":
    main()
