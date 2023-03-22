# Shell Command

`pwd` 当前文件夹

`cd` 切换目录 ～ 根目录 - 上一个目录 ..当前目录的上一个

`man [ls]` 查看[ ]的说明书 按 q 退出

`mv` 重命名或移动文件

`cp` 拷贝文件

`mkdir` 新建文件夹 `rmdir` 删除空文件夹

`rm` 删除 -r 删除路径下所有文件和文件夹

`ctrl+l` 清除整个页面 `command+l` 清除上一个命令

`sudo` 超级用户 `sudo su` 接下来使用超级用户执行命令

`sudo tee` `tee` 这个程序以 `root` 权限运行

`ls *.sh` 所有 sh 结尾的文件

## 程序间创造连接

`cat` > 输出 < 输入 overwrite >> append

pipes: `|` 取左侧程序的输出作为右侧程序的输入 e.g. `ls -l | tail`

## Shell Script

为变量赋值 `foo=bar` 访问它 `$foo`

```
echo "$foo"
# 打印 bar
echo '$foo'
# 打印 $foo
```

- `$0` - 脚本名
- `$1` 到 `$9` - 脚本的参数。 `$1` 是第一个参数，依此类推。
- `$@` - 所有参数
- `$#` - 参数个数
- `$?` - 前一个命令的返回值
- `$$` - 当前脚本的进程识别码
- `!!` - 完整的上一条命令，包括参数。常见应用：当你因为权限不足执行命令失败时，可以使用 `sudo !!`再尝试一次。
- `$_` - 上一条命令的最后一个参数。如果你正在使用的是交互式 shell，你可以通过按下 `Esc` 之后键入 . 来获取这个值。

```
false || echo "Oops, fail"
# Oops, fail

true || echo "Will not be printed"
#

true && echo "Things went well"
# Things went well

false && echo "Will not be printed"
#

false ; echo "This will always run"
# This will always run
```

当执行脚本时，我们经常需要提供形式类似的参数。bash 使我们可以轻松的实现这一操作，它可以基于文件扩展名展开表达式。这一技术被称为 shell 的 _通配_ （ _globbing_ ）

- 通配符 - 当你想要利用通配符进行匹配时，你可以分别使用 `?` 和 `*` 来匹配一个或任意个字符。例如，对于文件 `foo`, `foo1`, `foo2`, `foo10` 和 `bar`, `rm foo?`这条命令会删除 `foo1` 和 `foo2` ，而 `rm foo*` 则会删除除了 `bar`之外的所有文件。
- 花括号 `{}` - 当你有一系列的指令，其中包含一段公共子串时，可以用花括号来自动展开这些命令。这在批量移动或转换文件时非常方便。

```
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar

# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}
touch foo/x bar/y
# 比较文件夹 foo 和 bar 中包含文件的不同
diff <(ls foo) <(ls bar)
# 输出
# < x
# ---
# > y
```

也可以建立笛卡尔体系 比如 `touch project{1,2}/src/test/project{1,2,3}`

`diff <(ls foo) <(ls bar)` 比较两个文件夹子文件的差别

`shellcheck` 定位脚本错误

`shebang` `#! interpreter [optional-arg]` 当带有 shebang 的文本文件被用作类[Unix](https://en.wikipedia.org/wiki/Unix-like "类Unix")操作系统中的可执行文件时，[程序加载器](<https://en.wikipedia.org/wiki/Loader_(computing)>) "装载机（计算）")机制将文件初始行的其余部分解析为[解释器指令](https://en.wikipedia.org/wiki/Interpreter_directive "解释器指令")。加载程序执行指定的[解释器](<https://en.wikipedia.org/wiki/Interpreter_(computing)>) "口译员（计算机）")程序，将尝试运行脚本时最初使用的路径作为参数传递给它，以便程序可以将该文件用作输入数据。

## Shell Tools

tldr 不使用浏览器查看文档

### 查找文件

`find` 查找文件

```
# 查找所有名称为src的文件夹
find . -name src -type d
# 查找所有文件夹路径中包含test的python文件
find . -path '*/test/*.py' -type f
# 查找前一天修改的所有文件
find . -mtime -1
# 查找所有大小在500k至10M的tar.gz文件
find . -size +500k -size -10M -name '*.tar.gz'
```

对文件进行操作

```
# 删除全部扩展名为.tmp 的文件
find . -name '*.tmp' -exec rm {} \;
# 查找全部的 PNG 文件并将其转换为 JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

`fd` 更简单快速友好

`locate` 通过数据库查找

### 查找代码

`grep`

`grep` 有很多选项，这也使它成为一个非常全能的工具。其中我经常使用的有 `-C` ：获取查找结果的上下文（Context）；`-v` 将对结果进行反选（Invert），也就是输出不匹配的结果。举例来说， `grep -C 5` 会输出匹配结果前后五行。当需要搜索大量文件的时候，使用 `-R` 会递归地进入子目录并搜索所有的文本文件。

因此也出现了很多它的替代品，包括 [ack](https://beyondgrep.com/), [ag](https://github.com/ggreer/the_silver_searcher) 和 [rg](https://github.com/BurntSushi/ripgrep)。它们都特别好用，但是功能也都差不多，我比较常用的是 ripgrep (`rg`) ，因为它速度快，而且用法非常符合直觉。例子如下：

```
# 查找所有使用了 requests 库的文件
rg -t py 'import requests'
# 查找所有没有写 shebang 的文件（包含隐藏文件）
rg -u --files-without-match "^#!"
# 查找所有的foo字符串，并打印其之后的5行
rg foo -A 5
# 打印匹配的统计信息（匹配的行和文件的数量）
rg --stats PATTERN
```

### 查找 Shell 命令

- 上箭头
- `history`
- `history | grep find` 打印包含 find 子串的命令
- `control+R` 可以与 `fzf` 一起使用 模糊查找

`fish` 基于历史的自动补全 Type `fish` to start a shell `exit` to end the session

还有一些更复杂的工具可以用来概览目录结构，例如 [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) 或更加完整的文件管理器，例如 [`nnn`](https://github.com/jarun/nnn) 或 [`ranger`](https://github.com/ranger/ranger)。
