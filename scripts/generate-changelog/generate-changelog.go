package main

import (
	"flag"
	"os"

	"github.com/prometheus/promu/pkg/changelog"
	"github.com/sirupsen/logrus"
)

func main() {
	version := flag.String("version", "", "release version")
	flag.Parse()
	f, err := os.Open("CHANGELOG.md")
	if err != nil {
		logrus.Fatal(err)
	}
	defer f.Close()
	entry, err := changelog.ReadEntry(f, *version)
	if err != nil {
		logrus.WithError(err).Fatalf("unable to get the entry in the changelog for the version %q", *version)
	}
	err = os.WriteFile("GENERATED_CHANGELOG.md", []byte(entry.Text), 0600)
	if err != nil {
		logrus.WithError(err).Fatal("error when generating the changelog")
	}
}
