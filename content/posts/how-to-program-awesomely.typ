#import "/templates/fuwari.typ": post, admonition, code-block, quote-block, github-card, link-card, content-image, hr-line

#show: post.with(
  title: "如何漂亮地写代码",
  date: "2026-09-23",
  summary: "",
  tags: (),
  category: none,
  image: none,
  words: 1890,
  minutes: 6,
  draft: false,
)

有人说，AI 时代，没人自己写代码。如果有人说自己必须古法写代码才能解决问题，那么一定是他的模型用得不够好。他肯定是少装了什么 Skill 或者没给 A\\ 充钱。不错，我承认现在没几个人写代码；但是拿着 Vibe Coding 出来的 AI Slop 往别人的项目乱发 PR，或者往小红书上抱怨自己的“产品”无人问津，就是“程序员”自己的问题了。我们需要学习如何漂亮地写代码，至少掌握鉴赏漂亮代码的能力。


= 让编程语言有自然语言般的表现力

编程语言是一种语言。不论是自然语言还是形式语言，都有优美和糟糕之分。我们会对优美的文章大加赞叹，而排斥粗鄙之语。我们会对严谨的数学推理和优美的数学工具感兴趣，而对诡辩不感兴趣甚至感到恶心。编程语言也是如此。我们喜爱易读、如自然语言般流畅的代码风格，而拒绝 Review 那些耦合、晦涩、`i++ + ++i`的屎山。


== 给计算机安排工作——声明式编程

现代语言给了我们丰富的抽象工具，供我们写出清晰易懂且无需担心性能问题的代码。在此基础上，我们可以弱化实现细节，通过告诉计算机“我想要什么”而不是“应该怎么做”来写出可读性高的代码。

例如，我们在写 `SQL` 语言时会写出这样的语句：

#code-block("SELECT name FROM users WHERE age >= 18;", lang: "sql")

阅读这个句子，我们发现这就是一句语法通顺的英文：

#quote-block[
*Select* the value of `name` *from* each row in the table `users` *where* that row's `age` is *greater than or equal to* `18`.


]

我们没有像监工一样，命令计算机：

#code-block("for row <- users {\n    if row.age >= 18 {\n        tell me row.name \n    }\n}", lang: "plain")

而是像向一位绝顶聪明的助手“许愿”：

#quote-block[
把 `users` 这张表里面 `age` 大于等于 18 的行挑出来，取出 `name` 给我。


]

这更像数学里的描述式集合，简洁、纯粹、优雅：

$ "names" = { "row.name" | "row" in "users" and "row.name" >= 18 } $

再比如这段 Python 代码：

#code-block("l = [i * 2 for i in range(10)]", lang: "py")

他向计算机声明：我要把 `range(10)` 中每一个 i 乘上 2 放到一个列表里。
换做以前，我们会写：

#code-block("l = []\nfor i in range(10):\n    l.append(i * 2)", lang: "py")

例如，我们要将装有学生成绩的数组中及格线以上的学生过滤出来，然后按从分数低到高排列，我们该怎么做？

C 语言是一个古老但仍在系统和高性能编程发挥基石作用的语言。自从 1972 年诞生以来，它就几乎没有添加过新的语法，也自然没有现代语言赖以生存的现代特性。如下所示，这是上述问题的一个典型的 C 语言实现。

#code-block("\n#include <stdio.h>\n#include <stdlib.h>\n#define PASS 60\n\ntypedef struct {\n    char *name;\n    unsigned int score;\n} Student;\n\nint cmp(const void *a, const void *b) {\n    unsigned int score_a = ((const Student *)a)->score;\n    unsigned int score_b = ((const Student *)b)->score;\n    \n    if (score_a < score_b) return -1;\n    if (score_a > score_b) return 1;\n    return 0;\n}\n\nvoid filter_and_sort(const Student *src, Student *des, size_t size) {\n    size_t index = 0;\n    for (size_t i = 0; i < size; i++) {\n        if (src[i].score < PASS) continue;\n        des[index] = src[i]; // shallow copy\n        index++;\n    }\n    qsort(des, index, sizeof(Student), cmp);\n}\n", lang: "c")

由于 C++ 可认为是 C 语言的超集（实际上并不准确，因为 C++ 标准不允许 VLA 和一系列 C 特性），于是有人写出这样的 C++ 代码：

#code-block("#include <iostream>\n#include <vector>\n#include <range>\nusing namespace std;\n\nconstexpr int PASS = 60;\n\nstruct Student {\n    char *name;\n    unsigned int score;\n} ;\n\nstd::vector filter_and_sort(const std::vector& src) {\n    std::vector des;\n    for (const auto& student : src) {\n        if (student.score < PASS) continue;\n        des.push_back(student);\n    }\n    \n    std::ranges::sort(des, [](const auto &a, const auto &b) {\n        return a.score < b.score; \n    });\n    \n    return des;\n}", lang: "c++")

我们通过阅读代码并分析逻辑，发现这段实现几乎就是 C 的改写。从可读性上看，我们能不能做得更好？

#code-block("#include <vector>\n#include <ranges>\nusing namespace std;\nusing namespace std::views;\nusing namespace std::ranges;\n\nconstexpr int PASS = 60;\n\nstruct Student {\n    char *name;\n    unsigned int score;\n} ;\n\nstd::vector filter_and_sort(const std::vector& src) {\n    auto des = src | filter([](const auto &i) { return i.score >= PASS; })\n                   | to<vector>();\n    std::ranges::sort(des, std::greater{}, &Student::score);\n    return des;\n}", lang: "c++")

我们在语言层面直接描述 `filter` 和 `sort` 语义，而无需分析 `for` 语句块的逻辑。

让我们进一步用噪声更小的语言重写这段逻辑：

#code-block("struct Student {\n    name: String,\n    score: usize,\n}\n\nconst PASS: usize = 60;\n\nfn filter_and_sort(src: Vec<Student>) -> Vec<Student> {\n    let mut des = src.into_iter()\n        .filter(|s| s.score >= PASS)\n        .collect();\n\n    des.sort_by(|a, b| b.score.cmp(&a.score));\n    des\n}", lang: "rs")

我们发现，比起用复杂的流程叙述一个算法，让语言自己描述自己的功能更有可读性。


== 大胆抽象，交给编译器优化

有人说：让语言承担描述高级算法的职责，是否会拖慢运行速度？我认为，大部分情况是否定的。现代 C++ 和 Rust 遵循所谓零成本抽象原则，指的是不需要为没用到的东西付出代价；你用到的东西，你自己手写也不会比编译器生成的代码更高效。

在现代编译器看来，提供越多的信息，越能给编译器优化带来信心；反之，如果一门语言极其贴近硬件，程序员就不得不考虑编译器没考虑的部分，采用 hacky 手段来尽可能优化程序的性能。所谓“ C 语言是最快的语言”显然并不完全成立，对内存掌握不好的程序员，以及视 AI 为神明，认为 AI 能够抹除一切语言区别的 vibe coder 来说更是如此。我们来通过 memory aliasing 这个例子来详细说明。

#code-block("void compute(int* input, int* output) {\n    if (*input > 10) {\n        *output = 1;\n    }\n    if (*input > 5) {\n        *output *= 2;\n    }\n}", lang: "c")

这个函数能被优化成下面这个函数吗？

#code-block("void compute(int* input, int* output) {\n    int cached_input = *input;\n    if (cached_input > 10) {\n        *output = 2;\n    } else if (cached_input > 5) {\n        *output *= 2;\n    }\n}", lang: "c")

按照函数想要表达的逻辑来讲，这两个函数本质上做的是相同的事情。让我们把这两个函数编译成 x86-64 汇编：

#code-block("gcc -S main.c -O2 -fno-stack-protector", lang: "sh")

#code-block("compute1:\n.LFB0:\n\t.cfi_startproc\n\tmovl\t(%rdi), %eax   ; 第一次读取 *input\n\tcmpl\t$10, %eax\n\tjle\t.L2\n\tmovl\t$1, (%rsi)\n\tmovl\t(%rdi), %eax   ; 第二次读取 *input\n.L2:\n\tcmpl\t$5, %eax\n\tjle\t.L1\n\tsall\t(%rsi)\n.L1:\n\tret\n\t.cfi_endproc", lang: "asm")

#code-block("compute2:\n.LFB1:\n\t.cfi_startproc\n\tmovl\t(%rdi), %eax   ; 第一次读取 *input\n\tcmpl\t$10, %eax\n\tjle\t.L6\n\tmovl\t$2, (%rsi)\n\tret                    ; 发生了什么？\n.L6:\n\tcmpl\t$5, %eax\n\tjle\t.L5\n\tsall\t(%rsi)\n.L5:\n\tret\n\t.cfi_endproc", lang: "asm")

为什么第二个函数只读一次 `*input`，第一个函数必须读两次？如果我们在第一个函数加上 `restrict` 修饰符：

#code-block("void compute1(int* restrict input, int* restrict output) {\n    if (*input > 10) {\n        *output = 1;\n    }\n    if (*input > 5) {\n        *output *= 2;\n    }\n}", lang: "c")

#code-block("compute1:\n.LFB0:\n\t.cfi_startproc\n\tmovl\t(%rdi), %eax   ; 第一次读取 *input\n\tcmpl\t$10, %eax\n\tjg\t.L4\n\tcmpl\t$5, %eax\n\tjg\t.L6\n\tret\n\t.p2align 4,,10\n\t.p2align 3\n.L4:\n\tmovl\t$2, %eax\n\tmovl\t%eax, (%rsi)\n\tret\n.L6:\n\tmovl\t(%rsi), %eax\n\taddl\t%eax, %eax\n\tmovl\t%eax, (%rsi)\n\tret\n\t.cfi_endproc", lang: "asm")

我们发现 `*input` 只被读取了一次。

`restrict` 告诉编译器，这个修饰符修饰的变量不会被程序的其他部分改动，因此可以让编译器激进地优化。

注意看第一个函数的这一行：

#code-block("void compute1(int* input, int* output) {\n    if (*input > 10) {\n        *output = 1;\n    }\n    if (*input > 5) {\n        *output *= 2;\n    }\n}", lang: "c")

这里修改了 `*output`，鉴于 `output` 和 `input` 可能指向同一块内存，编译器不敢贸然做一些例如把 `*input` 放到寄存器里之类的优化。思考：如果我们加上 `restrict` 关键字，并让 `input` 和 `output` 指向了同一块内存，会发生什么事情？

我们运行

#code-block("#include <stdio.h>\n\nint main() {\n    int i = 11;\n    compute1(&i, &i);\n    printf(\"%d\\n\", i);\n}", lang: "c")

在 `-O2` 优化程度下，我们期望他输出 `1`，可是他输出了 `2`。但如果我们严格保证两个指针指向的内存不同，那么这个函数不会有任何计算问题。

可是不凑巧的是，普通 C 程序员并不会使用 `restrict` 来优化程序性能，AI 在没有提示词的情况下也不会主动写出 `restrict`，因此编译器难以优化这些 C 语言程序。

得益于 Rust 的“多读单写”原则，同一时间只可能出现某一个变量的唯一可变借用，所以当我们写出

#code-block("fn compute(input: &i32, output: &mut i32);", lang: "rs")

这样的签名时，编译器立即能够知道，`input` 和 `output` 不可能指向同一块内存。指向同一块内存的两个可变借用只可能在 unsafe 代码中出现，编译器能够大大方方优化，不必顾及先前提到的 memory aliasing 问题。


== 设计好接口，让你的代码变成文章

我们假设

- `a: Html`
- `b: Json`
- `c: Structure`
- `parse_html: Html -> Result<Json, E>`
- `parse_json: Json -> Result<Structure, E>`

#code-block("if a.is_ok() {\n    let a = a.unwrap();\n\n    let b = parse_html(a);\n\n    if b.is_ok() {\n        let b = b.unwrap();\n\n        let c = parse_json(b);\n\n        if c.is_ok() {\n            let c = c.unwrap();\n            ...\n        }\n    }\n}", lang: "rs")

这段代码显然看着很丑。

但如果我们充分利用所谓自函子范畴上的幺半群，让 `Result` 的 `and_then()` 来解释代码逻辑，那么这段代码将变成

#code-block("let result = a\n    .and_then(parse_html)\n    .and_then(parse_json);", lang: "rs")

我没解释，你看得懂吗？这就是好接口的魅力。

#code-block("pub const fn and_then<U, F>(self, op: F) -> Result<U, E>\n    where\n        F: [const] FnOnce(T) -> Result<U, E> + [const] Destruct,\n{\n    match self {\n        Ok(t) => op(t),\n        Err(e) => Err(e),\n    }\n}", lang: "rs")

`and_then` 让 Ok(t) 传给闭包运行，Err(e) 直接保持原样，短路透传，正好符合 `and_then` 函数名语义。其他语言有 `>>=`、`flatMap`、`bind` 等叫法，个人感觉都没有 `and_then` 清晰。漂亮的代码靠清晰的语义取胜，而非靠所谓炫技语法糖。


== 代码不言自明——少写注释

很多人会把注释的覆盖率当作评判一个项目的代码质量的标准。且看下面一段代码：

#code-block("int sum(int* array, size_t size) {\n    ...\n}", lang: "c")

和这一段代码：

#code-block("/** @param array 是一段\n ** \n ** \n */", lang: "c")


== 不要打断读者的心流状态——少用无意义的中间变量


= 留下代码六尺巷
