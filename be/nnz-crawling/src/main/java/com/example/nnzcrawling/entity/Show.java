package com.example.nnzcrawling.entity;

import com.example.nnzcrawling.dto.ShowDTO;
import io.github.eello.nnz.common.entity.BaseEntity;
import lombok.*;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "shows", uniqueConstraints = {
        @UniqueConstraint(name = "unique_constraint", columnNames = {"title", "startDate", "isDelete"})
})
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Where(clause = "is_delete = 0")
public class Show extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String location;

    private String startDate;

    private String endDate;

    private String ageLimit;

    private String region;

    @Column(length = 1000)
    private String posterImage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_code")
    private Category category;

    @OneToMany(mappedBy = "show")
    @Builder.Default
    private List<ShowTag> tags = new ArrayList<>();

    public void addTag(ShowTag tag) {
        if (this.tags == null) {
            this.tags = new ArrayList<>();
        }

        this.tags.add(tag);
        tag.setShow(this);
    }

    public static Show of(ShowCrawling v, Category category) {
        return Show.builder()
                .title(v.getTitle())
                .location(v.getLocation())
                .startDate(v.getStartDate())
                .endDate(v.getEndDate())
                .ageLimit(v.getAgeLimit())
                .region(v.getRegion())
                .posterImage(v.getPosterImage())
                .category(category)
                .tags(new ArrayList<>())
                .build();
    }

    public static Show dtoToEntity(ShowDTO showDTO, Category category) {
        return Show.builder()
                .title(showDTO.getTitle())
                .location(showDTO.getLocation())
                .startDate(showDTO.getStartDate())
                .endDate(showDTO.getEndDate())
                .ageLimit(showDTO.getAgeLimit())
                .region(showDTO.getRegion())
                .posterImage(showDTO.getPosterImage())
                .category(category)
                .build();
    }

    public void deleteShow() {
        this.isDelete = true;
    }
}
