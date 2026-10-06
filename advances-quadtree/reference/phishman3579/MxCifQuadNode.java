 protected static class MxCifQuadNode<AABB extends AxisAlignedBoundingBox> extends QuadNode<AABB> {

            protected static double minWidth = 1;
            protected static double minHeight = 1;

            protected List<AABB> aabbs = new LinkedList<AABB>();

            protected MxCifQuadNode(AxisAlignedBoundingBox aabb) {
                super(aabb);
            }

            /**
             * {@inheritDoc}
             * 
             * returns True if inserted or already contains.
             */
            @Override
            protected boolean insert(AABB b) {
                // Ignore objects which do not belong in this quad tree
                if (!aabb.intersectsBox(b)) 
                    return false; // object cannot be added
                if (aabbs.contains(b)) 
                    return true; // already exists

                // Subdivide then add the objects to whichever node will accept it
                if (isLeaf()) 
                    subdivide(b);

                boolean inserted = false;
                if (isLeaf()) {
                    aabbs.add(b);
                    inserted = true;
                } else {                
                    inserted = insertIntoChildren(b);
                }

                if (!inserted) {
                    // Couldn't insert into children (it could strattle the bounds of the box)
                    aabbs.add(b);
                    return true;
                }
                return true;
            }

            /**
             * {@inheritDoc}
             * 
             * This method does not merge children.
             */
            @Override
            protected boolean remove(AABB b) {
                // If not in this AABB, don't do anything
                if (!aabb.intersectsBox(b)) 
                    return false;

                // If in this AABB and in this node
                if (aabbs.remove(b)) 
                    return true;

                // If this node has children
                if (!isLeaf()) {
                    // If in this AABB but in a child branch
                    return removeFromChildren(b);
                }

                return false;
            }

            /**
             * {@inheritDoc}
             */
            @Override
            protected int size() {
                return aabbs.size();
            }

            private boolean subdivide(AABB b) {
                double w = aabb.width/2d;
                double h = aabb.height/2d;
                if (w<minWidth || h<minHeight) return false;

                AxisAlignedBoundingBox aabbNW = new AxisAlignedBoundingBox(aabb,w,h);
                northWest = new MxCifQuadNode<AABB>(aabbNW);

                XYPoint xyNE = new XYPoint(aabb.x+w,aabb.y);
                AxisAlignedBoundingBox aabbNE = new AxisAlignedBoundingBox(xyNE,w,h);
                northEast = new MxCifQuadNode<AABB>(aabbNE);

                XYPoint xySW = new XYPoint(aabb.x,aabb.y+h);
                AxisAlignedBoundingBox aabbSW = new AxisAlignedBoundingBox(xySW,w,h);
                southWest = new MxCifQuadNode<AABB>(aabbSW);

                XYPoint xySE = new XYPoint(aabb.x+w,aabb.y+h);
                AxisAlignedBoundingBox aabbSE = new AxisAlignedBoundingBox(xySE,w,h);
                southEast = new MxCifQuadNode<AABB>(aabbSE);

                return insertIntoChildren(b);
            }

            private boolean insertIntoChildren(AABB b) {
                //Try to insert into all children
                if (northWest.aabb.insideThis(b) && northWest.insert(b)) return true;
                if (northEast.aabb.insideThis(b) && northEast.insert(b)) return true;
                if (southWest.aabb.insideThis(b) && southWest.insert(b)) return true;
                if (southEast.aabb.insideThis(b) && southEast.insert(b)) return true;
                return false;
            }

            private boolean removeFromChildren(AABB b) {
                // A AABB can only live in one child.
                if (northWest.remove(b)) return true;
                if (northEast.remove(b)) return true;
                if (southWest.remove(b)) return true;
                if (southEast.remove(b)) return true;
                return false; // should never happen
            }

            /**
             * {@inheritDoc}
             */
            @Override
            protected void queryRange(AxisAlignedBoundingBox range, List<AABB> geometricObjectsInRange) {
                // Automatically abort if the range does not collide with this quad
                if (!aabb.intersectsBox(range)) 
                    return;

                // Check objects at this level
                for (AABB b : aabbs) {
                    if (range.intersectsBox(b)) 
                        geometricObjectsInRange.add(b);
                }

                // Otherwise, add the objects from the children
                if (!isLeaf()) {
                    northWest.queryRange(range,geometricObjectsInRange);
                    northEast.queryRange(range,geometricObjectsInRange);
                    southWest.queryRange(range,geometricObjectsInRange);
                    southEast.queryRange(range,geometricObjectsInRange);
                }
            }

            /**
             * {@inheritDoc}
             */
            @Override
            public String toString() {
                StringBuilder builder = new StringBuilder();
                builder.append(super.toString()).append(", ");
                builder.append("[");
                for (AABB p : aabbs)
                    builder.append(p).append(", ");
                builder.append("]");
                return builder.toString();
            }
        }