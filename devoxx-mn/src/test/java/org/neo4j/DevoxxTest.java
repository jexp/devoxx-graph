package org.neo4j;

import io.micronaut.runtime.EmbeddedApplication;
import io.micronaut.test.extensions.junit5.annotation.MicronautTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;

import jakarta.inject.Inject;

@MicronautTest
class DevoxxTest {

    @Inject
    EmbeddedApplication<?> application;

    @Inject
    DevoxxController controller;

    @Test
    void testItWorks() {
        Assertions.assertTrue(application.isRunning());
    }
    @Test
    void testTalks() {
        Assertions.assertEquals(216, controller.talks().size());
    }

}
