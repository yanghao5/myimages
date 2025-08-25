package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("请指定子命令")
		os.Exit(1)
	}

	subcmd := os.Args[1]
	if !isValidAction(subcmd) {
		cmd := strings.Join(os.Args, " ")
		fmt.Println("error: invalid cmd ", cmd)
		os.Exit(1)
	}

	switch subcmd {
	case "debian127":
		runnerCmd := flag.NewFlagSet("debian127", flag.ExitOnError)
		apt := runnerCmd.String("apt", "none", "配置文件路径")

		if err := runnerCmd.Parse(os.Args[2:]); err != nil {
			fmt.Printf("解析参数失败: %v\n", err)
			os.Exit(1)
		}

		debian127(*apt)
	case "clean":
		clean()
	default:
		fmt.Printf("未知命令: %s\n", subcmd)
		os.Exit(1)
	}

}

func debian127(apt string) {
	cmds := []string{}

	currentTime := time.Now()
	timeString := currentTime.Format("200601021504")

	tag := "debian127" + ":" + timeString

	switch apt {
	case "none":
		cmds = []string{
			"docker", "build",
			"-f", "Dockerfile.debian.v12_7",
			"-t", tag,
			".",
		}
	case "tencent":
		cmds = []string{
			"docker", "build",
			"-f", "Dockerfile.debian.v12_7",
			"--build-arg", "APT_MIRROR=apt-mirror/tencent",
			"-t", tag,
			".",
		}
	case "tencent_vps":
		cmds = []string{
			"docker", "build",
			"-f", "Dockerfile.debian.v12_7",
			"--build-arg", "APT_MIRROR=apt-mirror/tencent_vps",
			"-t", tag,
			".",
		}
	}

	cmd := exec.Command(cmds[0], cmds[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		fmt.Println("cmd exec error:", err)
		return
	}
}

func clean() {
	cmds := []string{
		"docker", "system", "prune", "-a", "--volumes", "-f",
	}
	cmd := exec.Command(cmds[0], cmds[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		fmt.Println("cmd exec error:", err)
		return
	}
}

// 定义合法的字符串集合
var validActions = map[string]bool{
	"debian127": true,
	"clean":     true,
}

func isValidAction(action string) bool {
	return validActions[action]
}
