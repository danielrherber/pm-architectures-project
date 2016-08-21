__author__ = 'Tinghao Guo'

import igraph
import numpy as np

def detectiso(adj1,adj2, node_color1, node_color2):

    # convert to arrays
    # adj1 = np.array(adj1)
    # adj2 = np.array(adj2)
    adj1 = np.matrix(adj1)
    adj2 = np.matrix(adj2)


    # create graphs
    g1 = igraph.Graph.Adjacency((adj1 > 0).tolist(), mode = igraph.ADJ_MAX)
    g2 = igraph.Graph.Adjacency((adj2 > 0).tolist(), mode = igraph.ADJ_MAX)

    # g1 = igraph.Graph.Adjacency(adj1, mode = igraph.ADJ_MAX)
    # g2 = igraph.Graph.Adjacency(adj2, mode = igraph.ADJ_MAX)

    g1.es['weight'] = adj1[adj1.nonzero()]
    # g1.vs['label'] = node_names
    # g1.vs['color'] = node_colors

    g2.es['weight'] = adj2[adj2.nonzero()]
    # g2.vs['label'] = node_names
    # g2.vs['color'] = node_colors

    iso = g1.isomorphic_vf2(g2, color1 = node_color1, color2 = node_color2)
    #  should return false
    # iso = g1.isomorphic_vf2(g2, color1 = [1,2,3], color2 = [1,2,3])

    return iso