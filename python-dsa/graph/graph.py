

class Graph:
    def __init__(self, numvertex):
        self.adjMatrix = [[0]*numvertex for x in range(numvertex)]
        self.numvertex = numvertex
        self.vertices = {}
        self.verticesList = [0]*numvertex

    def set_vertex(self, vtx, id):
        if 0<=vtx<=self.numvertex:
            self.vertices[id] = vtx
            self.verticesList[vtx] = id

    def set_edge(self, frm, to, cost=0):
        frm = self.vertices[frm]
        to = self.vertices[to]
        self.adjMatrix[frm][to] = cost
        # only from undirected graphs
        self.adjMatrix[to][frm] = cost

    def get_vertex(self):
        return self.verticesList

    def get_edges(self):
        edges = []
        for i in range(self.numvertex):
            for j in range(self.numvertex):
                if (self.adjMatrix[i][j] != -1):
                    edges.append((self.verticesList[i], self.verticesList[j], self.adjMatrix[i][j] ))
        return edges

    def get_matrix(self):
        return self.adjMatrix




