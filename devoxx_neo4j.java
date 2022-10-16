//JAVA 17
///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS info.picocli:picocli-codegen:4.6.2 org.neo4j.driver:neo4j-java-driver:4.3.6 org.reactivestreams:reactive-streams:1.0.3

import java.util.concurrent.Callable;
import java.util.Map;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Config;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Logging;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

@Command(name = "hello_neo4j")
public class devoxx_neo4j implements Callable<Integer> {

    @Option(names = "-u", description = "Neo4j user", required = true, defaultValue = "${env:NEO4J_USERNAME}")
    String username;

    @Option(names = "-p", description = "Password of the provided Neo4j user", required = true,defaultValue = "${env:NEO4J_PASSWORD}")
    String password;

    @Option(names = "-t", description = "Tag name", required = true, defaultValue="java")
    String tag;

    @Parameters(index = "0", description = "URI to connect to (defaults to neo4j://localhost:7687)", paramLabel = "URI", defaultValue = "${env:NEO4J_URI:-neo4j://localhost:7687}")
    String uri;

    public static void main(String... args) {
        int exitCode = new CommandLine(new devoxx_neo4j()).execute(args);
    }

    @Override
    public Integer call() throws Exception {
        try (var driver = GraphDatabase.driver(uri, AuthTokens.basic(username, password))) {

            printTalks(driver);

        }
        return 0;
    };

    private static final String QUERY = """
        MATCH (sp:Speaker)-[:PRESENTS]->(t:Talk)-[:TAGGED]->(tag:Tag) 
        WHERE toLower(tag.name) contains toLower($tag)
        RETURN t.title as title, sp.name as name
        LIMIT 10
        """;

    private void printTalks(Driver driver) {
        try (var session = driver.session()) {
            var result = session.readTransaction(t ->
              t.run(QUERY,Map.of("tag",tag))
               .list(r -> r.asMap()));
            result.forEach(System.out::println);
        }
    }

}
