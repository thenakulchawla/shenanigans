  protected static class TreePrinter {

        public static <T extends XYPoint> String getString(QuadTree<T> tree) {
            if (tree.getRoot() == null) return "Tree has no nodes.";
            return getString(tree.getRoot(), "", true);
        }

        private static <T extends XYPoint> String getString(QuadNode<T> node, String prefix, boolean isTail) {
            StringBuilder builder = new StringBuilder();

            builder.append(prefix + (isTail ? "└── " : "├── ") + " node={" + node.toString() + "}\n");
            List<QuadNode<T>> children = null;
            if (node.northWest != null || node.northEast != null || node.southWest != null || node.southEast != null) {
                children = new ArrayList<QuadNode<T>>(4);
                if (node.northWest != null) children.add(node.northWest);
                if (node.northEast != null) children.add(node.northEast);
                if (node.southWest != null) children.add(node.southWest);
                if (node.southEast != null) children.add(node.southEast);
            }
            if (children != null) {
                for (int i = 0; i < children.size() - 1; i++) {
                    builder.append(getString(children.get(i), prefix + (isTail ? "    " : "│   "), false));
                }
                if (children.size() >= 1) {
                    builder.append(getString(children.get(children.size() - 1), prefix + (isTail ? "    " : "│   "), true));
                }
            }

            return builder.toString();
        }
    }