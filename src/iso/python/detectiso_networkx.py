import networkx as nx
import numpy as np

def detectiso(adj1, adj2, node_color1, node_color2, n1, n2):

    adj1 = np.matrix(adj1)
    adj2 = np.matrix(adj2)

    adj1 = np.reshape(adj1, [n1,n1])
    adj2 = np.reshape(adj2, [n2,n2])

    g1 = nx.from_numpy_matrix(adj1,create_using=nx.MultiGraph())
    g2 = nx.from_numpy_matrix(adj2,create_using=nx.MultiGraph())

    for x in range(0, n1):
        g1.nodes[x]['color'] = node_color1[x]

    for x in range(0, n2):
        g2.nodes[x]['color'] = node_color2[x]

    isoflag = nx.is_isomorphic(g1,g2,node_match=colors_match)

    return isoflag

def colors_match(n1_attrib,n2_attrib):
    '''returns False if either does not have a color or if the colors do not match'''
    try:
        return n1_attrib['color']==n2_attrib['color']
    except KeyError:
        return False