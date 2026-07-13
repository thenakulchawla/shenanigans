package commitparser

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

type GitStruct struct {
	Commit string
	Author string
	Email  string

	Date        string
	Title       string
	Description string
}

// key changes:
// - change to switch case since its easier to handle then if else
// - return error
// - for description we need to figure out if we are in description
// and if we are we need to append to those.

// lukea@nvidia.com

func transform(input string) ([]*GitStruct, error) {

	var curr *GitStruct
	var arr []*GitStruct

	r := bufio.NewReader(strings.NewReader(input))
	var inDescription bool
	var descriptionLines strings.Builder

	for {
		line, _, err := r.ReadLine()
		if err == io.EOF {
			if curr != nil {
				arr = append(arr, curr)
			}
			break
		}

		if err != nil {
			fmt.Println("error is: ", err)
			return []*GitStruct{}, err
		}

		lineToStr := strings.TrimSpace(string(line))
		if lineToStr == "" {
			continue
		}

		words := strings.Fields(string(line))

		switch words[0] {

		case "commit":
			if curr != nil {
				if descriptionLines.Len() > 0 {
					descriptionLines.WriteString(lineToStr)
				}
				arr = append(arr, curr)
			}

			curr = &GitStruct{
				Commit: words[1],
			}
			inDescription = false
			descriptionLines = strings.Builder{}

		case "Author:":
			if curr != nil {
				email := words[len(words)-1]
				curr.Email = strings.Trim(email, "<>")
				authorName := strings.Join(words[1:len(words)-1], " ")
				curr.Author = authorName

			}

		case "Date:":
			if curr != nil {
				curr.Date = strings.Join(words[1:], " ")
			}
		default:
			if curr != nil && curr.Date != "" {
				if curr.Title == "" {
					curr.Title = lineToStr
				} else if inDescription {
					descriptionLines.WriteString(lineToStr)
				}

			}

		}

	}

	return arr, nil
}

func PrintTransformation(s string) {
	commits, err := transform(s)
	if err != nil {
		fmt.Println(err)
		return
	}
	for _, commit := range commits {
		if commit.Description != "" {
			fmt.Printf("Commit: %s | Author: %s | Email: %s | Date: %s | Title: %s | Description: %s\n",
				commit.Commit,
				commit.Author,
				commit.Email,
				commit.Date,
				commit.Title,
				commit.Description)
		} else {
			fmt.Printf("Commit: %s | Author: %s | Email: %s | Date: %s | Title: %s\n",
				commit.Commit,
				commit.Author,
				commit.Email,
				commit.Date,
				commit.Title)
		}
	}

}
