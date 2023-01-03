TOTAL = "total"
RUDRA = "rudra"
AAMIR = "aamir"
JITESH = "jitesh"
NAKUL = "nakul"
AMUL = "amul"
PREET = "preet"
SURABHI = "surabhi"
NAKUL_WATCH = "nakul_watch"
DISCOUNT = "discount"


def take_input():
    all = {}
    all[TOTAL] = float(input("total: "))
    all[DISCOUNT] = float(input("discount: "))

    all[RUDRA] = float(input("rudra: "))
    all[AAMIR] = float(input("aamir: "))
    all[JITESH] = float(input("jitesh: "))
    all[NAKUL] = float(input("nakul: "))
    all[AMUL] = float(input("amul:"))
    all[PREET] = float(input("preetesh: "))
    all[SURABHI] = float(input("surabhi: "))
    all[NAKUL_WATCH] = float(input("nakul_watch: "))
    return all


def calculate(input_map: map):
    print(input_map[DISCOUNT])
    participants = len(input_map)-2
    print(participants)
    discount_per_person = input_map[DISCOUNT] / participants
    for key in input_map:
        input_map[key] -= discount_per_person
    input_map = aggregate(input_map)
    return


def aggregate(input_map: map):
    input_map[NAKUL] += input_map[NAKUL_WATCH]
    input_map[PREET] += input_map[SURABHI]
    del input_map[NAKUL_WATCH]
    del input_map[SURABHI]
    del input_map[TOTAL]
    del input_map[DISCOUNT]

    new_total = 0

    for key in input_map:
        new_total += input_map[key]

    input_map[TOTAL] = new_total

    return input_map


def print_output(input_map: map):
    for key in input_map:
        print(str(key) + ": " + str(input_map[key]))
    return


if __name__ == "__main__":
    input_map = take_input()
    calculate(input_map)
    print_output(input_map)
