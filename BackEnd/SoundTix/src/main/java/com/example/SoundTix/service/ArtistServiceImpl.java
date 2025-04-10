package com.example.SoundTix.service;

import com.example.SoundTix.dao.ArtistSearch;
import com.example.SoundTix.model.Artist;
import com.example.SoundTix.model.Event;
import com.example.SoundTix.repository.ArtistRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ArtistServiceImpl implements ArtistService{
    @Autowired
    private ArtistRepository artistRepository;

    @Override
    public Artist addArtist(Artist artist) {
        return artistRepository.save(artist);
    }

    public long countAllArtists() { return artistRepository.count(); }

    @Override
    public long countFilteredArtists(ArtistSearch artistSearch) {
        return artistRepository.count(new Specification<Artist>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Artist> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(artistSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + artistSearch.getName() + "%"));
                }
                if(!ObjectUtils.isEmpty(artistSearch.getGenre())){
                    predicates.add(criteriaBuilder.equal(root.get("genre"), artistSearch.getGenre()));
                }
                if(!ObjectUtils.isEmpty(artistSearch.getNationality())){
                    predicates.add(criteriaBuilder.equal(root.get("nationality"), artistSearch.getNationality()));
                }
                if (!ObjectUtils.isEmpty(artistSearch.getEvent())) {
                    Join<Artist, Event> eventJoin = root.join("events");
                    predicates.add(criteriaBuilder.equal(eventJoin.get("name"), artistSearch.getEvent()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    @Override
    public Optional<Artist> getArtistById(Integer artistId) {
        return artistRepository.findById(artistId);
    }

    @Override
    public Artist updateArtist(Integer artistId, Artist artistDetails) {
        Optional<Artist> artist = artistRepository.findById(artistId);
        if (artist.isPresent()) {
            Artist existingArtist = artist.get();
            if (artistDetails.getName() != null) {
                existingArtist.setName(artistDetails.getName());
            }
            if (artistDetails.getSex() != null) {
                existingArtist.setSex(artistDetails.getSex());
            }
            if (artistDetails.getGenre() != null) {
                existingArtist.setGenre(artistDetails.getGenre());
            }
            if (artistDetails.getBirthDay() != null) {
                existingArtist.setBirthDay(artistDetails.getBirthDay());
            }
            if (artistDetails.getNationality() != null) {
                existingArtist.setNationality(artistDetails.getNationality());
            }
            if (artistDetails.getBio() != null) {
                existingArtist.setBio(artistDetails.getBio());
            }
            if (artistDetails.getDebutDate() != null) {
                existingArtist.setDebutDate(artistDetails.getDebutDate());
            }
            if (artistDetails.getAvatar() != null) {
                existingArtist.setAvatar(artistDetails.getAvatar());
            }
            return artistRepository.save(existingArtist);
        }
        return null;
    }

    @Override
    public void deleteAllArtists() {
        artistRepository.deleteAll();
    }

    @Override
    public void deleteArtist(Integer artistId) {
        artistRepository.deleteById(artistId);
    }

    @Override
    public Page<Artist> findArtist(ArtistSearch artistSearch, Pageable pageable){
        return artistRepository.findAll(new Specification<Artist>() {
            @Override
            public Predicate toPredicate(Root<Artist> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(artistSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + artistSearch.getName() + "%"));
                }
                if(!ObjectUtils.isEmpty(artistSearch.getGenre())){
                    predicates.add(criteriaBuilder.equal(root.get("genre"), artistSearch.getGenre()));
                }
                if(!ObjectUtils.isEmpty(artistSearch.getNationality())){
                    predicates.add(criteriaBuilder.equal(root.get("nationality"), artistSearch.getNationality()));
                }
                if (!ObjectUtils.isEmpty(artistSearch.getEvent())) {
                    Join<Artist, Event> eventJoin = root.join("events");
                    predicates.add(criteriaBuilder.equal(eventJoin.get("name"), artistSearch.getEvent()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

