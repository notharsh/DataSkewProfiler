import xml.etree.cElementTree as ET
tree = ET.ElementTree(file='test.xml')
root = tree.getroot()
print (root)
print (root.tag,root.attrib)

for c in root:
	if c.tag == 'Graphs':
		graphNode = c
		break
imp = graphNode
#print(graphNode.tag,graphNode.attrib)


def indent(e, level=0):
    i = "\n" + level*"  "
    j = "\n" + (level-1)*"  "
    if len(e):
        if not e.text or not e.text.strip():
            e.text = i + "  "
        if not e.tail or not e.tail.strip():
            e.tail = i
        for s in e:
            indent(s, level+1)
        if not e.tail or not e.tail.strip():
            e.tail = j
    else:
        if level and (not e.tail or not e.tail.strip()):
            e.tail = j
    return e        


indent(root)
#ET.dump(root)

#indent(graphNode)
#ET.dump(graphNode)

graphs = []
count = 0 
def find_rec(node, element):
    def _find_rec(node, element, result):
        for el in node.getchildren():
            _find_rec(el, element, result)
        if node.tag == element:
            result.append(node)
    res = list()
    _find_rec(node, element, res)
    return res


def extract(x,graphs):
	for c in x:
		if(c.tag == "Graph"):
			graphs.append(c)
	#print (nodes)
	return graphs

g_list = extract(imp,graphs)
print(g_list)
atts = []
atts = find_rec(g_list[0],"att")
#print(atts)'atts= g_list[0].iter("att")
atts = atts[:len(atts)-2]

for a in atts:
	if (a.attrib['name'] == '_kind'):
		print(a.attrib['value'])