import torch


def main():
    print("Hello from learnml!")

    device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
    print(device)  # should print: mps


if __name__ == "__main__":
    main()
