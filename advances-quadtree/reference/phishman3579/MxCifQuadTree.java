/**
     * MX-CIF quadtree is a variant of quadtree data structure which supports area-based query. It is designed for storing a
     * set of rectangles (axis-aligned bounded box) in a dynamic environment.
     */
    public static class MxCifQuadTree<B extends AxisAlignedBoundingBox> extends QuadTree<B> {

        private static final XYPoint XY_POINT = new XYPoint();
        private static final AxisAlignedBoundingBox RANGE = new AxisAlignedBoundingBox();

        private MxCifQuadNode<B> root = null;

        /**
         * Create a quadtree who's upper left coordinate is located at x,y and it's bounding box is described
         * by the height and width. This uses a default leafCapacity of 4 and a maxTreeHeight of 20.
         *
         * @param x Upper left X coordinate
         * @param y Upper left Y coordinate
         * @param width Width of the bounding box containing all points
         * @param height Height of the bounding box containing all points
         */
        public MxCifQuadTree(double x, double y, double width, double height) {
            this(x,y,width,height,0,0);
        }

        /**
         * Create a quadtree who's upper left coordinate is located at x,y and it's bounding box is described
         * by the height and width. This uses a default leafCapacity of 4 and a maxTreeHeight of 20.
         *
         * @param x Upper left X coordinate
         * @param y Upper left Y coordinate
         * @param width Width of the bounding box containing all points
         * @param height Height of the bounding box containing all points
         * @param minWidth The tree will stop splitting when leaf node's width <= minWidth
         * @param minHeight The tree will stop splitting when leaf node's height <= minHeight
         */
        public MxCifQuadTree(double x, double y, double width, double height, double minWidth, double minHeight) {
            XYPoint xyPoint = new XYPoint(x,y);
            AxisAlignedBoundingBox aabb = new AxisAlignedBoundingBox(xyPoint,width,height);
            MxCifQuadNode.minWidth = minWidth;
            MxCifQuadNode.minHeight = minHeight;
            root = new MxCifQuadNode<B>(aabb);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public QuadNode<B> getRoot() {
            return root;
        }

        /**
         * {@inheritDoc}
         * 
         * Assumes height and width of 1
         */
        @Override
        public boolean insert(double x, double y) {
            return insert(x,y,1,1);
        }

        /**
         * Insert rectangle whose upper-left point is located at X,Y and has a height and width into tree.
         * 
         * @param x X position of upper-left hand corner.
         * @param y Y position of upper-left hand corner.
         * @param width Width of the rectangle.
         * @param height Height of the rectangle.
         */
        public boolean insert(double x, double y, double width, double height) {
            XYPoint xyPoint = new XYPoint(x,y);
            AxisAlignedBoundingBox range = new AxisAlignedBoundingBox(xyPoint,width,height);

            return root.insert((B)range);
        }

        /**
         * {@inheritDoc}
         * 
         * Assumes height and width of 1
         */
        @Override
        public boolean remove(double x, double y) {
            return remove(x,y,1,1);
        }

        /**
         * Remove rectangle whose upper-left point is located at X,Y and has a height and width into tree.
         * 
         * @param x X position of upper-left hand corner.
         * @param y Y position of upper-left hand corner.
         * @param width Width of the rectangle.
         * @param height Height of the rectangle.
         */
        public boolean remove(double x, double y, double width, double height) {
            XY_POINT.set(x,y);
            RANGE.set(XY_POINT,width,height);

            return root.remove((B)RANGE);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public Collection<B> queryRange(double x, double y, double width, double height) {
            if (root == null) 
                return Collections.EMPTY_LIST;

            XY_POINT.set(x,y);
            RANGE.set(XY_POINT,width,height);

            List<B> geometricObjectsInRange = new LinkedList<B>();
            root.queryRange(RANGE,geometricObjectsInRange);
            return geometricObjectsInRange;
        }

       
    }