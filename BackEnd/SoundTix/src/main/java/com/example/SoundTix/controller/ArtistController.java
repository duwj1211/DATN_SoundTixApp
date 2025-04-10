package com.example.SoundTix.controller;

import com.example.SoundTix.dao.ArtistSearch;
import com.example.SoundTix.model.Artist;
import com.example.SoundTix.pojo.ArtistResponse;
import com.example.SoundTix.service.ArtistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/artist")
public class ArtistController {
    @Autowired
    private ArtistService artistService;

    @PostMapping("/add")
    public Artist addArtist(@RequestBody Artist artist){
        return artistService.addArtist(artist);
    }

    @GetMapping("/{artistId}")
    public Optional<Artist> getArtistById(@PathVariable Integer artistId){
        return artistService.getArtistById(artistId);
    }

    @PatchMapping("update/{artistId}")
    public Artist updateArtist(@PathVariable Integer artistId, @RequestBody Artist artistDetails){
        return artistService.updateArtist(artistId, artistDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllArtists(){
        artistService.deleteAllArtists();
        return "All artists have been deleted successfully.";
    }

    @DeleteMapping("/delete/{artistId}")
    public void deleteArtist(@PathVariable Integer artistId){
        artistService.deleteArtist(artistId);
    }

    @PostMapping("/search")
    public ResponseEntity<ArtistResponse> searchArtists(
            @RequestBody(required = false) ArtistSearch artistSearch,
            Pageable pageable) {

        if (artistSearch == null) {
            artistSearch = new ArtistSearch();
        }

        Page<Artist> artistPage = artistService.findArtist(artistSearch, pageable);

        long totalArtists = artistService.countFilteredArtists(artistSearch);

        ArtistResponse response = new ArtistResponse(
                artistPage.getContent(),
                totalArtists
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

