package com.wnwl.CPN2025.serial;

/**
 * Class declaration
 *
 * @author
 * @version 1.7, 05/04/00
 */
public class SerialConnectionException extends Exception {
    private static final long serialVersionUID = 6844988626042683588L;

    /**
     * Constructs a <code>SerialConnectionException</code>
     * with the specified detail message.
     *
     * @param s the detail message.
     */
    public SerialConnectionException(String str) {
        super(str);
    }

    /**
     * Constructs a <code>SerialConnectionException</code>
     * with no detail message.
     */
    public SerialConnectionException() {
        super();
    }

}




