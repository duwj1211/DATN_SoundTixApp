package com.example.SoundTix.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "feedback")
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer feedbackId;
    @Column(columnDefinition = "TEXT")
    private String title;
    @Column(columnDefinition = "TEXT")
    private String content;
    private String type;
    @Temporal(TemporalType.TIMESTAMP)
    private Date feedbackTime;
    private String status;
    private Integer starCount;
    private String reply;
    @Temporal(TemporalType.TIMESTAMP)
    private Date replyTime;
    private Integer reaction;
    @PrePersist
    protected void onCreate() {
        this.feedbackTime = new Date();
        if (this.reply == null || this.reply.isEmpty()) {
            this.status = "Unresponded";
        }
    }

    @ManyToOne
    @JoinColumn(name = "userId")
    @JsonIgnoreProperties("feedbacks")
    private User user;

    @ManyToOne
    @JoinColumn(name = "eventId")
    @JsonIgnoreProperties("feedbacks")
    private Event event;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(Integer feedbackId) {
        this.feedbackId = feedbackId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getFeedbackTime() {
        return feedbackTime;
    }

    public void setFeedbackTime(Date feedbackTime) {
        this.feedbackTime = feedbackTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getStarCount() {
        return starCount;
    }

    public void setStarCount(Integer starCount) {
        this.starCount = starCount;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        if (!reply.equals(this.reply)) {
            this.reply = reply;
            this.replyTime = new Date();
            this.status = (reply != null && !reply.isEmpty()) ? "Responded" : "Unresponded";
        }
    }

    public Date getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(Date replyTime) {
        this.replyTime = replyTime;
    }

    public Integer getReaction() {
        return reaction;
    }

    public void setReaction(Integer reaction) {
        this.reaction = reaction;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }
}
