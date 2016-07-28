package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.PrivActor;
import com.wnwl.CPN2025.hdao.PrivActorDAO;

import java.util.List;

public class PrivActorDAOImpl extends BaseDAOImpl<PrivActor, Integer> implements PrivActorDAO {

    public PrivActorDAOImpl() {
        super(PrivActor.class);
    }

    public List<PrivActor> getPrivActor(Integer userId) {
        String hql = "select a.privActor from PrivActorUser a where a.userInfo.id = " + userId;
        List<PrivActor> privActors = super.findAnyObjects(hql);
        return privActors;
    }

}
