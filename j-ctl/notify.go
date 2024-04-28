package main

import (
	"fmt"
	"os/exec"
)

type Notification struct {
	Title     string
	Body      string
	Transient bool
	Hints     []NotificationHintValue
}

func (n Notification) WithHint(key NotificationHint, value any) Notification {
	n.Hints = append(n.Hints, NotificationHintValue{
		Key:   key,
		Value: value,
	})
	return n
}

func (n Notification) Send() error {
	args := []string{}
	if n.Transient {
		args = append(args, "--transient")
	}
	for _, hint := range n.Hints {
		args = append(args, "-h", hint.String())
	}
	args = append(args, n.Title)
	if n.Body != "" {
		args = append(args, n.Body)
	}
	_, err := exec.Command("notify-send", args...).Output()
	if err != nil {
		return err
	}
	return nil
}

type NotificationHintValue struct {
	Key   NotificationHint
	Value any
}

func (n NotificationHintValue) String() string {
	if v, ok := n.Value.(int); ok {
		return fmt.Sprintf("int:%s:%d", n.Key, v)
	}
	if v, ok := n.Value.(string); ok {
		return fmt.Sprintf("string:%s:%s", n.Key, v)
	}
	if v, ok := n.Value.(float32); ok {
		return fmt.Sprintf("double:%s:%f", n.Key, v)
	}
	if v, ok := n.Value.(bool); ok {
		return fmt.Sprintf("boolean:%s:%t", n.Key, v)
	}

	return ""
}

type NotificationHint string

const (
	HintForegroundColor NotificationHint = "fgcolor"
	HintBackgroundColor NotificationHint = "bgcolor"
	HintFrameColor      NotificationHint = "frcolor"
	HintHighlightColor  NotificationHint = "hlcolor"
	HintProgressValue   NotificationHint = "value"
	HintImagePath       NotificationHint = "image-path"
	HintImageData       NotificationHint = "image-data"
	HintCategory        NotificationHint = "category"
	HintDesktopEntry    NotificationHint = "desktop-entry"
	HintTransientId     NotificationHint = "transient"
)
