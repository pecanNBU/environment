package com.wnwl.CPN2025.serial;

import java.util.Observable;
import java.util.Observer;

public class CommDataObserver implements Observer {
    String name;

    public CommDataObserver(String name) {
        this.name = name;
    }

    public void update(Observable o, Object arg) {
        System.out.println("[" + name + "] GetMessage:\n [" + new String((byte[]) arg) + "]");
    }
}