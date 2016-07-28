package com.wnwl.CPN2025.hdao;

import com.wnwl.CPN2025.bhh.PrivActor;

import java.util.List;

public interface PrivActorDAO extends BaseDAO<PrivActor, Integer> {

    List<PrivActor> getPrivActor(Integer userId);

}