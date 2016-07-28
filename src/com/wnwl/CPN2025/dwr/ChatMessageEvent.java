package com.wnwl.CPN2025.dwr;

import org.springframework.context.ApplicationEvent;

public class ChatMessageEvent extends ApplicationEvent {
    private static final long serialVersionUID = 1L;

    public ChatMessageEvent(Object source) {
        super(source);
    }
}
