package com.jwetherell.algorithms.data_structures;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;

/**
 * A quadtree is a tree data structure in which each internal node has exactly four children. Quadtrees 
 * are most often used to partition a two dimensional space by recursively subdividing it into four 
 * quadrants or regions. The regions may be square or rectangular, or may have arbitrary shapes.
 * 
 * http://en.wikipedia.org/wiki/Quadtree
 * 
 * @author Justin Wetherell <phishman3579@gmail.com>
 */
@SuppressWarnings("unchecked")
public abstract class QuadTree<G extends XYPoint> {

    /**
     * Get the root node.
     * 
     * @return Root QuadNode.
     */
    protected abstract QuadNode<G> getRoot();

    /**
     * Range query of the quadtree.
     */
    public abstract Collection<G> queryRange(double x, double y, double width, double height);

    /**
     * Insert point at X,Y into tree.
     * 
     * @param x X position of point.
     * @param y Y position of point.
     */
    public abstract boolean insert(double x, double y);

    /**
     * Remove point at X,Y from tree.
     * 
     * @param x X position of point.
     * @param y Y position of point.
     */
    public abstract boolean remove(double x, double y);

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return TreePrinter.getString(this);
    }


}