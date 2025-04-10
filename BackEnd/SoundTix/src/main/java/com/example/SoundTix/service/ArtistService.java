package com.example.SoundTix.service;


import com.example.SoundTix.dao.ArtistSearch;
import com.example.SoundTix.model.Artist;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface ArtistService {
    Artist addArtist(Artist artist);
    public long countAllArtists();
    public long countFilteredArtists(ArtistSearch artistSearch);
    Optional<Artist> getArtistById(Integer artistId);
    Artist updateArtist(Integer artistId, Artist artistDetails);
    void deleteAllArtists();
    void deleteArtist(Integer artistId);
    Page<Artist> findArtist(ArtistSearch artistSearch, Pageable pageable);
}

