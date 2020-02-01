import igraph as ig
import numpy as np

def detectiso(adj1, adj2, nlabel1, nlabel2, n1, n2, isotype):

    adj1 = np.matrix(adj1)
    adj2 = np.matrix(adj2)

    adj1 = np.reshape(adj1, [n1,n1])
    adj2 = np.reshape(adj2, [n2,n2])

    if isotype == 0: # simple check
        g1 = ig.Graph.Adjacency(adj1.tolist(), mode = ig.ADJ_MAX)
        g2 = ig.Graph.Adjacency(adj2.tolist(), mode = ig.ADJ_MAX)
        iso = g1.isomorphic_vf2(g2)

    elif isotype == 1: # label weights needed
        g1 = ig.Graph.Adjacency(adj1.tolist(), mode = ig.ADJ_MAX)
        g2 = ig.Graph.Adjacency(adj2.tolist(), mode = ig.ADJ_MAX)
        iso = g1.isomorphic_vf2(g2,nlabel1,nlabel2)

    elif isotype == 2: # edge weights needed
        g1 = ig.Graph.Weighted_Adjacency(adj1.tolist(), mode = ig.ADJ_MAX)
        g2 = ig.Graph.Weighted_Adjacency(adj2.tolist(), mode = ig.ADJ_MAX)
        iso = g1.isomorphic_vf2(g2,edge_color1=g1.es["weight"],edge_color2=g2.es["weight"])

    elif isotype == 3: # both label and edge weights needed
        g1 = ig.Graph.Weighted_Adjacency(adj1.tolist(), mode = ig.ADJ_MAX)
        g2 = ig.Graph.Weighted_Adjacency(adj2.tolist(), mode = ig.ADJ_MAX)
        iso = g1.isomorphic_vf2(g2,nlabel1,nlabel2,g1.es["weight"],g2.es["weight"])

    return iso