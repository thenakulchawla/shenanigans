
from graph import Graph

if __name__ == "__main__":
    G=Graph(6)
    G.set_vertex(0,'a')
    G.set_vertex(1,'b')
    G.set_vertex(2,'c')
    G.set_vertex(3,'d')
    G.set_vertex(4,'e')
    G.set_vertex(5,'f')
    G.set_edge('a','e',10)
    G.set_edge('a','c',10)
    G.set_edge('c','b',10)
    G.set_edge('b','e',10)
    G.set_edge('e','d',10)
    G.set_edge('f','e',10)
    print("Vertices of graph")
    print(G.get_vertex())
    print("Edges of graph")
    print(G.get_edges())
    print("Adjacency matrix")
    print(G.get_matrix())
