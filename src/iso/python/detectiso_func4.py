__author__ = 'Daniel Herber and Tinghao Guo'

import igraph
import numpy as np

def detectiso(adj1, adj2, node_color1, node_color2, n1, n2):

    adj1 = np.matrix(adj1)
    adj2 = np.matrix(adj2)

    adj1 = np.reshape(adj1, [n1,n1])
    adj2 = np.reshape(adj2, [n2,n2])
    
    g1 = igraph.Graph.Adjacency(adj1.tolist(), mode = igraph.ADJ_MAX)
    g2 = igraph.Graph.Adjacency(adj2.tolist(), mode = igraph.ADJ_MAX)

    iso = g1.isomorphic_vf2(g2, color1 = node_color1, color2 = node_color2)

    return iso