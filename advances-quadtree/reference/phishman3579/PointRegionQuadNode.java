  protected static class PointRegionQuadNode<XY extends XYPoint> extends QuadNode<XY> {

            // max number of children before sub-dividing
            protected static int maxCapacity = 0;
            // max height of the tree (will over-ride maxCapacity when height==maxHeight)
            protected static int maxHeight = 0;

            protected List<XY> points = new LinkedList<XY>();
            protected int height = 1;

            protected PointRegionQuadNode(AxisAlignedBoundingBox aabb) {
                super(aabb);
            }

            /**
             * {@inheritDoc}
             * 
             * returns True if inserted.
             * returns False if not in bounds of tree OR tree already contains point.
             */
            @Override
            protected boolean insert(XY p) {
                // Ignore objects which do not belong in this quad tree
                if (!aabb.containsPoint(p) || (isLeaf() && points.contains(p))) 
                    return false; // object cannot be added

                // If there is space in this quad tree, add the object here
                if ((height==maxHeight) || (isLeaf() && points.size() < maxCapacity)) {
                    points.add(p);
                    return true;
                }

                // Otherwise, we need to subdivide then add the point to whichever node will accept it
                if (isLeaf() && height<maxHeight) 
                    subdivide();
                return insertIntoChildren(p);
            }

            /**
             * {@inheritDoc}
             * 
             * This method will merge children into self if it can without overflowing the maxCapacity param.
             */
            @Override
            protected boolean remove(XY p) {
                // If not in this AABB, don't do anything
                if (!aabb.containsPoint(p)) 
                    return false;

                // If in this AABB and in this node
                if (points.remove(p)) 
                    return true;

                // If this node has children
                if (!isLeaf()) {
                    // If in this AABB but in a child branch
                    boolean removed = removeFromChildren(p);
                    if (!removed) 
                        return false;
    
                    // Try to merge children
                    merge();
    
                    return true;
                }

                return false;
            }

            /**
             * {@inheritDoc}
             */
            @Override
            protected int size() {
                return points.size();
            }

            private void subdivide() {
                double h = aabb.height/2d;
                double w = aabb.width/2d;

                AxisAlignedBoundingBox aabbNW = new AxisAlignedBoundingBox(aabb,w,h);
                northWest = new PointRegionQuadNode<XY>(aabbNW);
                ((PointRegionQuadNode<XY>)northWest).height = height+1;

                XYPoint xyNE = new XYPoint(aabb.x+w,aabb.y);
                AxisAlignedBoundingBox aabbNE = new AxisAlignedBoundingBox(xyNE,w,h);
                northEast = new PointRegionQuadNode<XY>(aabbNE);
                ((PointRegionQuadNode<XY>)northEast).height = height+1;

                XYPoint xySW = new XYPoint(aabb.x,aabb.y+h);
                AxisAlignedBoundingBox aabbSW = new AxisAlignedBoundingBox(xySW,w,h);
                southWest = new PointRegionQuadNode<XY>(aabbSW);
                ((PointRegionQuadNode<XY>)southWest).height = height+1;

                XYPoint xySE = new XYPoint(aabb.x+w,aabb.y+h);
                AxisAlignedBoundingBox aabbSE = new AxisAlignedBoundingBox(xySE,w,h);
                southEast = new PointRegionQuadNode<XY>(aabbSE);
                ((PointRegionQuadNode<XY>)southEast).height = height+1;

                // points live in leaf nodes, so distribute
                for (XY p : points)
                    insertIntoChildren(p);
                points.clear();
            }

            private void merge() {
                // If the children aren't leafs, you cannot merge
                if (!northWest.isLeaf() || !northEast.isLeaf() || !southWest.isLeaf() || !southEast.isLeaf()) 
                    return;

                // Children and leafs, see if you can remove point and merge into this node
                int nw = northWest.size();
                int ne = northEast.size();
                int sw = southWest.size();
                int se = southEast.size();
                int total = nw+ne+sw+se;

                // If all the children's point can be merged into this node
                if ((size()+total) < maxCapacity) {
                    this.points.addAll(((PointRegionQuadNode<XY>)northWest).points);
                    this.points.addAll(((PointRegionQuadNode<XY>)northEast).points);
                    this.points.addAll(((PointRegionQuadNode<XY>)southWest).points);
                    this.points.addAll(((PointRegionQuadNode<XY>)southEast).points);

                    this.northWest = null;
                    this.northEast = null;
                    this.southWest = null;
                    this.southEast = null;
                }
            }

            private boolean insertIntoChildren(XY p) {
                // A point can only live in one child.
                if (northWest.insert(p)) return true;
                if (northEast.insert(p)) return true;
                if (southWest.insert(p)) return true;
                if (southEast.insert(p)) return true;
                return false; // should never happen
            }

            private boolean removeFromChildren(XY p) {
                // A point can only live in one child.
                if (northWest.remove(p)) return true;
                if (northEast.remove(p)) return true;
                if (southWest.remove(p)) return true;
                if (southEast.remove(p)) return true;
                return false; // should never happen
            }

            /**
             * {@inheritDoc}
             */
            @Override
            protected void queryRange(AxisAlignedBoundingBox range, List<XY> pointsInRange) {
                // Automatically abort if the range does not collide with this quad
                if (!aabb.intersectsBox(range)) 
                    return;

                // If leaf, check objects at this level
                if (isLeaf()) {
                    for (XY xyPoint : points) {
                        if (range.containsPoint(xyPoint)) 
                            pointsInRange.add(xyPoint);
                    }
                    return;
                }

                // Otherwise, add the points from the children
                northWest.queryRange(range,pointsInRange);
                northEast.queryRange(range,pointsInRange);
                southWest.queryRange(range,pointsInRange);
                southEast.queryRange(range,pointsInRange);
            }

            /**
             * {@inheritDoc}
             */
            @Override
            public String toString() {
                StringBuilder builder = new StringBuilder();
                builder.append(super.toString()).append(", ");
                builder.append("[");
                for (XYPoint p : points) {
                    builder.append(p).append(", ");
                }
                builder.append("]");
                return builder.toString();
            }
        }