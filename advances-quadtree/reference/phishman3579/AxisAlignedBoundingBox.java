public static class AxisAlignedBoundingBox extends XYPoint {

        private double height = 0;
        private double width = 0;

        private double minX = 0;
        private double minY = 0;
        private double maxX = 0;
        private double maxY = 0;

        public AxisAlignedBoundingBox() { }

        public AxisAlignedBoundingBox(XYPoint upperLeft, double width, double height) {
            super(upperLeft.x, upperLeft.y);
            this.width = width;
            this.height = height;

            minX = upperLeft.x;
            minY = upperLeft.y;
            maxX = upperLeft.x+width;
            maxY = upperLeft.y+height;
        }

        public void set(XYPoint upperLeft, double width, double height) {
            set(upperLeft.x, upperLeft.y);
            this.width = width;
            this.height = height;

            minX = upperLeft.x;
            minY = upperLeft.y;
            maxX = upperLeft.x+width;
            maxY = upperLeft.y+height;
        }

        public double getHeight() {
            return height;
        }
        public double getWidth() {
            return width;
        }

        public boolean containsPoint(XYPoint p) {
            if (p.x>=maxX) return false;
            if (p.x<minX) return false;
            if (p.y>=maxY) return false;
            if (p.y<minY) return false;
            return true;
        }

        /**
         * Is the inputted AxisAlignedBoundingBox completely inside this AxisAlignedBoundingBox.
         * 
         * @param b AxisAlignedBoundingBox to test.
         * @return True if the AxisAlignedBoundingBox is completely inside this AxisAlignedBoundingBox.
         */
        public boolean insideThis(AxisAlignedBoundingBox b) {
            if (b.minX >= minX && b.maxX <= maxX && b.minY >= minY && b.maxY <= maxY) {
                // INSIDE
                return true;
            }
            return false;
        }

        /**
         * Is the inputted AxisAlignedBoundingBox intersecting this AxisAlignedBoundingBox.
         * 
         * @param b AxisAlignedBoundingBox to test.
         * @return True if the AxisAlignedBoundingBox is intersecting this AxisAlignedBoundingBox.
         */
        public boolean intersectsBox(AxisAlignedBoundingBox b) {
            if (insideThis(b) || b.insideThis(this)) {
                // INSIDE
                return true;
            }

            // OUTSIDE
            if (maxX < b.minX || minX > b.maxX) return false;
            if (maxY < b.minY || minY > b.maxY) return false;

            // INTERSECTS
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            int hash = super.hashCode();
            hash = hash * 13 + (int)height;
            hash = hash * 19 + (int)width;
            return hash; 
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (obj == null)
                return false;
            if (!(obj instanceof AxisAlignedBoundingBox))
                return false;

            AxisAlignedBoundingBox aabb = (AxisAlignedBoundingBox) obj;
            return compareTo(aabb) == 0;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int compareTo(Object o) {
            if ((o instanceof AxisAlignedBoundingBox)==false)
                throw new RuntimeException("Cannot compare object.");

            AxisAlignedBoundingBox a = (AxisAlignedBoundingBox) o;
            int p = super.compareTo(a);
            if (p!=0) return p;

            if (height>a.height) return 1;
            if (height<a.height) return -1;

            if (width>a.width) return 1;
            if (width<a.width) return -1;

            return 0;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append("(");
            builder.append(super.toString()).append(", ");
            builder.append("height").append("=").append(height).append(", ");
            builder.append("width").append("=").append(width);
            builder.append(")");
            return builder.toString();
        }
    }