package org.neo4j.devoxx;

import org.springframework.boot.*;
import java.util.*;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.neo4j.core.schema.*;
import static org.springframework.data.neo4j.core.schema.Relationship.Direction.*;
import org.springframework.data.neo4j.repository.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.data.neo4j.repository.config.*;

@SpringBootApplication
@EnableNeo4jRepositories(considerNestedRepositories=true)
public class DevoxxApplication implements CommandLineRunner {

	@Autowired TalkRepository repo;

	public static void main(String[] args) {
		SpringApplication.run(DevoxxApplication.class, args);
	}

	public void run(String...args) {
		repo.findByTitleContaining(args[0]).forEach(System.out::println);
	}

	public interface TalkRepository extends Neo4jRepository<Talk, Long> {
		List<Talk> findByTitleContaining(String title);
	}

	@Node
    static class Talk {
		@Id
		Long id;
		String title;
		@Relationship(type="TAGGED", direction=OUTGOING)
		List<Tag> tags;
		public String toString() { return title + " " + tags; }
	}
	@Node
    static class Speaker {
		@Id
		Long id;
		String name;
		@Relationship(type="PRESENTS", direction=OUTGOING)
		List<Talk> talks;
		public String toString() { return name + " " + talks; }
	}
	@Node
    static class Tag {
		@Id
		String name;

		public String toString() { return name; }
	}

}
