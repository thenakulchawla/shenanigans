   /**
     * A PR (Point Region) Quadtree is a four-way search trie. This means that each node has either 
     * four (internal guide node) or zero (leaf node) children. Keys are only stored in the leaf nodes, 
     * all internal nodes act as guides towards the keys.
     * 
     * This implementation is a PR QuadTree which uses "Buckets" to prevent stalky trees.
     */
public static class PointRegionQuadTree<P extends XYPoint> extends QuadTree<P> {

        private static final XYPoint XY_POINT = new XYPoint();
        private static final AxisAlignedBoundingBox RANGE = new AxisAlignedBoundingBox();

        private PointRegionQuadNode<P> root = null;

        /**
         * Create a quadtree who's upper left coordinate is located at x,y and it's bounding box is described
         * by the height and width. This uses a default leafCapacity of 4 and a maxTreeHeight of 20.
         *
         * @param x Upper left X coordinate
         * @param y Upper left Y coordinate
         * @param width Width of the bounding box containing all points
         * @param height Height of the bounding box containing all points
         */
        public PointRegionQuadTree(double x, double y, double width, double height) {
            this(x,y,width,height,4,20);
        }

        /**
         * Create a quadtree who's upper left coordinate is located at x,y and it's bounding box is described
         * by the height and width.
         * 
         * @param x Upper left X coordinate
         * @param y Upper left Y coordinate
         * @param width Width of the bounding box containing all points
         * @param height Height of the bounding box containing all points
         * @param leafCapacity Max capacity of leaf nodes. (Note: All data is stored in leaf nodes)
         */
        public PointRegionQuadTree(double x, double y, double width, double height, int leafCapacity) {
            this(x,y,width,height,leafCapacity,20);
        }

        /**
         * Create a quadtree who's upper left coordinate is located at x,y and it's bounding box is described
         * by the height and width.
         * 
         * @param x Upper left X coordinate
         * @param y Upper left Y coordinate
         * @param width Width of the bounding box containing all points
         * @param height Height of the bounding box containing all points
         * @param leafCapacity Max capacity of leaf nodes. (Note: All data is stored in leaf nodes)
         * @param maxTreeHeight Max height of the quadtree. (Note: If this is defined, the tree will ignore the 
         *                                                   max capacity defined by leafCapacity)
         */
        public PointRegionQuadTree(double x, double y, double width, double height, int leafCapacity, int maxTreeHeight) {
            XYPoint xyPoint = new XYPoint(x,y);
            AxisAlignedBoundingBox aabb = new AxisAlignedBoundingBox(xyPoint,width,height);
            PointRegionQuadNode.maxCapacity = leafCapacity;
            PointRegionQuadNode.maxHeight = maxTreeHeight;
            root = new PointRegionQuadNode<P>(aabb);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public QuadNode<P> getRoot() {
            return root;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean insert(double x, double y) {
            XYPoint xyPoint = new XYPoint(x,y);

            return root.insert((P)xyPoint);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean remove(double x, double y) {
            XY_POINT.set(x,y);

            return root.remove((P)XY_POINT);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public Collection<P> queryRange(double x, double y, double width, double height) {
            if (root == null) 
                return Collections.EMPTY_LIST;

            XY_POINT.set(x,y);
            RANGE.set(XY_POINT,width,height);

            List<P> pointsInRange = new LinkedList<P>();
            root.queryRange(RANGE,pointsInRange);
            return pointsInRange;
        }
    }