protected static abstract class QuadNode<G extends XYPoint> implements Comparable<QuadNode<G>> {

        protected final AxisAlignedBoundingBox aabb;

        protected QuadNode<G> northWest = null;
        protected QuadNode<G> northEast = null;
        protected QuadNode<G> southWest = null;
        protected QuadNode<G> southEast = null;

        protected QuadNode(AxisAlignedBoundingBox aabb) {
            this.aabb = aabb;
        }

        /**
         * Insert object into tree.
         * 
         * @param g Geometric object to insert into tree.
         * @return True if successfully inserted.
         */
        protected abstract boolean insert(G g);

        /**
         * Remove object from tree.
         * 
         * @param g Geometric object to remove from tree.
         * @return True if successfully removed.
         */
        protected abstract boolean remove(G g);

        /**
         * How many GeometricObjects this node contains.
         * 
         * @return Number of GeometricObjects this node contains.
         */
        protected abstract int size();

        /**
         * Find all objects which appear within a range.
         * 
         * @param range Upper-left and width,height of a axis-aligned bounding box.
         * @param geometricObjectsInRange Geometric objects inside the bounding box. 
         */
        protected abstract void queryRange(AxisAlignedBoundingBox range, List<G> geometricObjectsInRange);

        /**
         * Is current node a leaf node.
         * @return True if node is a leaf node.
         */
        protected boolean isLeaf() {
            return (northWest==null && northEast==null && southWest==null && southEast==null);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            int hash = aabb.hashCode();
            hash = hash * 13 + ((northWest!=null)?northWest.hashCode():1);
            hash = hash * 17 + ((northEast!=null)?northEast.hashCode():1);
            hash = hash * 19 + ((southWest!=null)?southWest.hashCode():1);
            hash = hash * 23 + ((southEast!=null)?southEast.hashCode():1);
            return hash; 
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (obj == null)
                return false;
            if (!(obj instanceof QuadNode))
                return false;

            QuadNode<G> qNode = (QuadNode<G>) obj;
            if (this.compareTo(qNode) == 0)
                return true;

            return false;
        }

        /**
         * {@inheritDoc}
         */
        @SuppressWarnings("rawtypes")
        @Override
        public int compareTo(QuadNode o) {
            return this.aabb.compareTo(o.aabb);
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append(aabb.toString());
            return builder.toString();
        }
    }