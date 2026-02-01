package dao;

import model.Dojo;

import java.util.List;

public interface DojoDAO extends CrudDAO<Dojo, String>{
    long count();
    List<Dojo> findByMasterId(String masterId);
}
