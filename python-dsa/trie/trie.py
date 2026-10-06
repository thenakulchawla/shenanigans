from typing import List


class TrieNode:

    def __init__(self):
        self.children = [None]*26
        self.end = False


class Trie:

    def __init__(self):
        self.root = self.get_node()

    def get_node(self):
        return TrieNode()

    def __char_to_index(self, ch):
        return ord(ch) - ord('a')

    def insert(self, key):
        p_crawl = self.root
        length = len(key)

        for level in range(length):
            index = self.__char_to_index(key[level])

            if not p_crawl.children[index]:
                p_crawl.children[index] = self.get_node()

            p_crawl = p_crawl.children[index]

        p_crawl.end = True


    def search(self, key) -> bool:
        p_crawl = self.root
        length = len(key)

        for level in range(length):
            index = self.__char_to_index(key[level])
            if not p_crawl.children[index]:
                return False
            p_crawl = p_crawl.children[index]

        return p_crawl.end


def replace_words(dictionary: List[str], sentence: str):
    t = Trie()
    for key in dictionary:
        t.insert(key)

    arr_sent = sentence.split(" ")

    for j in range(len(arr_sent)):
        for i in range(len(arr_sent[j])):
            if t.search(arr_sent[j][0:i]):
                arr_sent[j] = arr_sent[j][0:i]
                break

    new_sentence = ""
    for word in arr_sent:
        new_sentence += word + " "

    return new_sentence[0:len(new_sentence)-1]


def main():
    dictionary = ["cat","bat","rat"]
    sentence = "the cattle was rattled by the battery"

    print(replace_words(dictionary, sentence))


if __name__ == '__main__':
    main()




