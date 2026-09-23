#import "components.typ": (
  cmd, comment, diagram, error, inlinecode, key, mono, note, output, remote,
  sequence, shortcut, success, terminal, tree,
)
#import "../colors.typ": blue, green, orange, purple, red

= Linux и терминал

== Зачем Linux в научной работе

#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  [
    *На ноутбуке*

    Пишем код, читаем результаты, работаем с графическим интерфейсом.
  ],
  [
    *На сервере или кластере*

    Запускаем расчёты, храним данные, используем вычислительные
    ресурсы.
  ],
)

Терминал — не «чёрный экран для программистов», а точный способ давать
машине команды и воспроизводить работу.

== Базовая модель Linux

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .8em,
  [#diagram(
    "Ядро",
    [Распределяет ресурсы компьютера.],
    color: purple,
  )],
  [#diagram(
    "Программы",
    [Python, редактор, браузер.],
    color: blue,
  )],
  [#diagram(
    "Пользователь",
    [Управляет системой через GUI или shell.],
    color: green,
  )],
)

Linux — семейство операционных систем. *Дистрибутив* собирает ядро,
программы и настройки; Ubuntu — один из популярных примеров.

== Окно терминала и shell

#grid(
  columns: (1fr, .25fr, 1fr),
  align: center + horizon,
  [#diagram(
    "Окно терминала",
    [Окно, в котором виден текст.],
    color: blue,
  )],
  [#text(size: 1.5em)[→]],
  [#diagram(
    "Shell",
    [Читает команды и запускает программы.],
    color: green,
  )],
)

На сервере GUI часто нет: это экономит ресурсы и упрощает удалённую
работу.

== Как читать командную строку

#terminal([
  #cmd([pwd], dir: "~/project")
  #output[/home/yaroslav/project]
  #cmd[ls]
  #output[README.md input.inp run.sh scripts src]
])

Цветная часть до `\$` — приглашение shell: она сообщает, кто и где
работает. Пользователь вводит только текст *после* `\$`.

== Файловая система — одно дерево

#grid(
  columns: (0.85fr, 1.15fr),
  gutter: 1.2em,
  [#tree[`/
├── home
│   └── yaroslav
│       ├── project
│       └── data
├── etc
├── usr
├── var
└── tmp`]],
  [
    В Linux всё начинается от корня #inlinecode[/].

    - #inlinecode[/home] — домашние каталоги пользователей
    - #inlinecode[/etc] — системные настройки
    - #inlinecode[/usr] — большинство программ
    - #inlinecode[/var] — изменяемые данные и логи
    - #inlinecode[/tmp] — временные файлы
  ],
)

== Пути: абсолютные и относительные

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#note(
    "Абсолютный путь",
    [Начинается с #inlinecode[/].\
      #inlinecode[/home/yaroslav/projects/analysis.py]],
    color: blue,
  )],
  [#note(
    "Относительный путь",
    [Считается от текущей папки.\ #inlinecode[scripts/run.sh]],
    color: green,
  )],
)

- #inlinecode[\~] — домашний каталог пользователя;
- #inlinecode[.] — текущий каталог;
- #inlinecode[..] — каталог уровнем выше.

== Где я нахожусь?

#terminal([
  #cmd[pwd]
  #output[/home/yaroslav/project]
  #cmd[ls -ld scripts]
  #output[drwxr-xr-x 2 yaroslav students 4096 Mar 20 scripts]
  #cmd[cd scripts]
  #cmd([cd ..], dir: "~/project/scripts")
  #cmd[cd \~]
  #cmd([pwd], dir: "~")
  #output[/home/yaroslav]
])

#inlinecode[pwd] — где мы; #inlinecode[ls -ld scripts] — сведения о папке;
#inlinecode[cd] — переход между папками.

== Создаём, копируем, перемещаем

#terminal([
  #cmd[mkdir results]
  #cmd[touch notes.txt]
  #cmd[cp input.inp input.backup]
  #cmd[mv notes.txt README-notes.txt]
  #cmd[mkdir empty-directory]
  #cmd[rmdir empty-directory]
])

#inlinecode[mkdir] создаёт каталог, #inlinecode[touch] — пустой файл,
#inlinecode[cp] копирует, #inlinecode[mv] перемещает или
переименовывает.

== Смотрим содержимое и место на диске

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Текст и тип файла*

    #inlinecode[cat file.txt] — короткий файл\
    #inlinecode[less output.log] — листать большой файл\
    #inlinecode[head -n 20 file] / #inlinecode[tail -n 20 file]\
    #inlinecode[file trajectory.dump]
  ],
  [
    *Размеры и программы*

    #inlinecode[du -sh results/] — размер каталога\
    #inlinecode[df -h] — свободное место\
    #inlinecode[which python] — исполняемый файл в PATH\
    #inlinecode[whereis lammps] — связанные файлы\
    #inlinecode[clear] — очистить экран
  ],
)

== Осторожно: удаления часто необратимы

#terminal([
  #error[НЕ ЗАПУСКАТЬ]
  #comment[\# Опасный пример: никогда не вводите эту строку]
  #error[sudo rm -rf /]
  #error[Команда пытается удалить всё дерево файловой системы.]
])

#note(
  "Перед удалением",
  [#inlinecode[rm file] удаляет файл; #inlinecode[rm -r directory] —
    каталог с содержимым. Проверьте путь через #inlinecode[pwd] и
    #inlinecode[ls]. #inlinecode[rm -rf] не спрашивает
    подтверждения.],
  color: red,
)

== Wildcard `\*`: полезно, но опасно

#terminal([
  #cmd[ls \*.tmp]
  #output[cache.tmp failed-run.tmp notes.tmp]
  #cmd[rm \*.tmp]
])

`\*` разворачивается shell в список подходящих имён *до запуска
команды*. Сначала показывайте совпадения через #inlinecode[ls], затем
удаляйте только то, что действительно нужно.

== Права доступа

#terminal([
  #cmd[ls -l run.sh]
  #output[-rw-r--r-- 1 yaroslav students 428 Mar 20 10:18 run.sh]
])

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .7em,
  [*Владелец*\ первые три символа],
  [*Группа*\ следующие три],
  [*Остальные*\ последние три],
)

`r` — читать, `w` — менять, `x` — запускать / заходить в каталог.

== chmod и chown

#terminal([
  #cmd[chmod +x run.sh]
  #cmd[chmod 755 run.sh]
  #cmd[ls -l run.sh]
  #output[-rwxr-xr-x 1 yaroslav students 428 Mar 20 10:18 run.sh]
])

Число #inlinecode[755] читается тройками: 7 = rwx, 5 = r-x, 5 = r-x.
#inlinecode[chown user:group file] меняет владельца; обычно это делает
администратор или владелец с нужными правами.

== sudo: команда с правами администратора

#terminal([
  #cmd[apt update]
  #error[E: Could not open lock file ... Permission denied]
  #cmd[sudo apt update]
  #success[Пакетные списки обновлены]
])

`sudo command` временно запускает *одну* команду от имени
администратора. Не работайте постоянно под root: ошибка с правами root
обходится системе гораздо дороже.

== Потоки и pipe

#grid(
  columns: (1fr, .3fr, 1fr, .3fr, 1fr),
  align: center + horizon,
  [#diagram("команда", [обычный вывод], color: blue)],
  [→],
  [#diagram("pipe: |", [передаёт текст], color: purple)],
  [→],
  [#diagram("следующая команда", [получает текст], color: green)],
)

У процесса есть ввод, обычный вывод и сообщения об ошибках. Shell
умеет соединять их без промежуточных файлов.

== Перенаправление и pipeline

#terminal([
  #cmd[ls -la | less]
  #comment[\# закрываем less клавишей q]
  #cmd[ps aux | grep python]
  #cmd[python analysis.py > output.txt]
  #cmd[python analysis.py >> run.log]
])

#inlinecode[>] создаёт или перезаписывает файл, #inlinecode[>>]
дописывает в конец, #inlinecode[|] передаёт stdout другой программе.
Ошибки можно отдельно направить через #inlinecode[2> errors.log].

== Поиск: grep и find

#terminal([
  #cmd[find . -name "\*.py"]
  #output[./src/analysis.py]
  #output[./scripts/plot.py]
  #cmd[grep -R "TODO" .]
  #output[./src/analysis.py:\# TODO: validate units]
])

#inlinecode[find] ищет по именам и условиям; #inlinecode[grep] ищет
текст внутри файлов.

== Маленькие инструменты, большой результат

#terminal([
  #cmd([cut -d, -f2 data.csv | sort | uniq | wc -l], dir: "~")
  #output[12]
])

В примере #inlinecode[data.csv] лежит в домашнем каталоге и содержит
измерения: 12 разных значений во втором столбце.

- #inlinecode[sort] сортирует строки;
- #inlinecode[uniq] объединяет соседние одинаковые строки;
- #inlinecode[wc -l] считает строки;
- #inlinecode[cut] выделяет столбцы простого текстового формата.

== Процессы: что сейчас выполняется

#terminal([
  #cmd[ps aux | grep python]
  #output[yaroslav 4182 98.4 python simulation.py]
  #cmd[top]
  #output[PID USER %CPU COMMAND]
  #comment[\# q — выйти из top]
])

Процесс — запущенная программа с PID. #inlinecode[ps] показывает
снимок, #inlinecode[top] обновляет его; #inlinecode[htop] часто
удобнее, если установлен.

== Работающая программа: на экране и в фоне

#terminal([
  #cmd[python simulation.py &]
  #output[[1] 4182]
  #cmd[jobs]
  #output[[1]+ Running python simulation.py &]
  #cmd[fg %1]
  #comment[\# Ctrl+C — остановить расчёт, прежде чем вводить новые
    команды]
])

#shortcut[Ctrl][C] прерывает программу на экране. #shortcut[Ctrl][Z]
приостанавливает её; затем #inlinecode[bg] продолжает в фоне,
#inlinecode[fg] возвращает. На удалённом сервере это не заменяет tmux.

== Останавливать процесс — по нарастающей

#terminal([
  #cmd[kill 4182]
  #comment[\# просим процесс корректно завершиться]
  #comment[\# Только если процесс НЕ завершился: kill -9 4182]
])

Сначала сохраните данные и попробуйте #shortcut[Ctrl][C] или
#inlinecode[kill PID]. #inlinecode[kill -9] нельзя перехватить:
процесс не успеет убрать временные файлы.

== Установка программ: разные уровни

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#note(
    "Системный менеджер",
    [Ubuntu: #inlinecode[sudo apt update] и #inlinecode[sudo apt
        install tmux]. Ставит программы для ОС.],
    color: blue,
  )],
  [#note(
    "Менеджер языка",
    [#inlinecode[pip], #inlinecode[uv], #inlinecode[cargo] управляют
      библиотеками и инструментами конкретной экосистемы.],
    color: green,
  )],
)

Один и тот же пакет не всегда следует искать на обоих уровнях: сначала
поймите, что именно устанавливаете.

= SSH: работаем на другой машине

== Что делает SSH

#grid(
  columns: (1fr, .45fr, 1fr),
  align: center + horizon,
  [#diagram("Ноутбук", [ваш терминал], color: blue)],
  [#text(size: 1.35em)[→ SSH →]],
  [#diagram("Сервер", [удалённая машина], color: green)],
)

SSH открывает shell на удалённой машине через сеть. Вы видите
терминал, но команды, файлы и процессы находятся на сервере.

== Самое простое подключение

#terminal([
  #cmd[ssh yaroslav\@192.168.1.50]
  #remote([exit], host: "server")
])

#inlinecode[yaroslav] — пользователь на *удалённой* машине;
#inlinecode[\@] отделяет его от адреса. #inlinecode[exit] завершает
удалённую сессию и возвращает вас на ноутбук.

== Первое подключение: проверяем личность сервера

#terminal([
  #cmd[ssh yaroslav\@192.168.1.50]
  #output[The authenticity of host '192.168.1.50' can't be
    established.]
  #output[ED25519 key fingerprint is SHA256:...]
  #output[Are you sure you want to continue connecting
    (yes/no/[fingerprint])?]
])

Fingerprint нужно сверить с надёжным источником: документацией
кластера или администратором. После подтверждения ключ сервера
сохраняется в #inlinecode[\~/.ssh/known_hosts].

== SSH-ключ: что хранится на каждой машине

#grid(
  columns: (1fr, .35fr, 1fr),
  align: center + horizon,
  [#diagram(
    "Ваш ноутбук",
    [Закрытый ключ остаётся здесь.],
    color: blue,
  )],
  [#align(center)[→]],
  [#diagram(
    "Сервер",
    [Хранит открытый ключ.],
    color: green,
  )],
)

Закрытый ключ никуда не отправляется. Сервер проверяет, что он есть у
вас; открытый ключ лежит в #inlinecode[\~/.ssh/authorized_keys] на
сервере.

== Создаём ключ ED25519

#terminal([
  #cmd[ssh-keygen -t ed25519]
  #output[Your identification has been saved in
    /home/yaroslav/.ssh/id_ed25519]
  #output[Your public key has been saved in
    /home/yaroslav/.ssh/id_ed25519.pub]
  #cmd[chmod 700 \~/.ssh]
  #cmd[chmod 600 \~/.ssh/id_ed25519]
])

Private key — секрет: не отправляйте его почтой, в Git или на сервер.
Public key можно добавлять в authorised keys.

== Добавляем public key на сервер

#terminal([
  #cmd[ssh-copy-id yaroslav\@server.example.org]
  #output[Number of key(s) added: 1]
  #output[Now try logging in with: ssh yaroslav\@server.example.org]
])

Команда дописывает *public key* в #inlinecode[\~/.ssh/authorized_keys]
на сервере. Если `ssh-copy-id` недоступен, public key добавляют туда
вручную через защищённый канал.

== \~/.ssh/config: короткие и повторяемые команды

#terminal(
  [
    #output[Host chemistry]
    #output[#h(1.5em)HostName server.example.org]
    #output[#h(1.5em)User yaroslav]
    #output[#h(1.5em)IdentityFile \~/.ssh/id_ed25519]
    #output[]
    #output[Host cluster]
    #output[#h(1.5em)HostName cluster.example.org]
    #output[#h(1.5em)User yaroslav]
    #output[#h(1.5em)IdentityFile \~/.ssh/id_ed25519]
  ],
  padding-y: .85em,
)

== SSH config в действии и диагностика

#terminal([
  #cmd[ssh chemistry]
  #remote([exit], host: "server")
  #cmd[ssh -v chemistry]
  #comment[\# -vv и -vvv дают ещё больше диагностической информации]
  #comment[\# ServerAliveInterval=60 можно задать в ~/.ssh/config]
])

#inlinecode[Host] — псевдоним, #inlinecode[HostName] — адрес.
#inlinecode[ssh -v] — первый инструмент при проблемах.
`ServerAliveInterval` можно задать в config для keepalive; не
включайте `ForwardAgent` глобально без необходимости.

== Передаём файлы: scp и rsync

#terminal([
  #cmd[scp input.dat cluster:\~/project/]
  #cmd[scp cluster:\~/project/result.out .]
  #cmd[rsync -avP ./ cluster:\~/project/]
])

#inlinecode[scp] удобен для одного файла. #inlinecode[rsync -avP]
синхронизирует каталоги: `-a` сохраняет структуру, `-v` показывает
ход, `-P` показывает прогресс и позволяет продолжить передачу.

== Туннель SSH: доступ к сервису на сервере

#grid(
  columns: (1fr, .5fr, 1fr),
  align: center + horizon,
  [#diagram("localhost:8888", [браузер на ноутбуке], color: blue)],
  [#align(center)[SSH →]],
  [#diagram(
    "server localhost:8888",
    [Jupyter на сервере],
    color: green,
  )],
)

#terminal([#cmd[ssh -L 8888:localhost:8888 cluster]])

`-L` открывает *локальный* порт и передаёт его на указанный адрес с
точки зрения сервера. #inlinecode[ssh -D 1080 server] создаёт SOCKS
proxy — это другой, более общий режим.

== Базовая SSH-гигиена

- Используйте ключи и защищайте private key passphrase.
- Не копируйте private key на сервер и не коммитьте его.
- Не отключайте проверку host key «чтобы быстрее подключиться».
- Не входите под root без необходимости.
- Открывайте наружу только действительно нужные сервисы.

== Проблема длинного расчёта

#terminal([
  #cmd[ssh cluster]
  #remote[python long_calculation.py]
  #error[Connection to cluster closed by remote host.]
])

Если Wi-Fi пропал, SSH-сессия завершается. Запущенный процесс может
получить hangup и остановиться. Нужна сессия, которая живёт на
сервере.

= tmux

== tmux: рабочее окно на сервере

#grid(
  columns: (1fr, .25fr, 1fr),
  align: center + horizon,
  [#diagram("Ноутбук", [SSH], color: blue)],
  [#text(size: 1.3em)[→]],
  [#diagram("Сервер", [tmux\ ↓\ расчёт продолжается], color: green)],
)

tmux создаёт рабочее окно на сервере. SSH можно отключить; tmux и
запущенные внутри него программы продолжают работать.

== Минимальный workflow tmux

#terminal([
  #remote[tmux new -s calc]
  #remote[python simulation.py]
  #comment[\# Ctrl+b, затем d — вернуться в shell сервера]
  #remote[tmux ls]
  #output[calc: 1 windows (created Wed Sep 23) (detached)]
  #remote[tmux attach -t calc]
])

Выйдя из сессии через #sequence[Ctrl+B][D], можно закрыть SSH.
Ненужную сессию удаляют командой #inlinecode[tmux kill-session -t
  calc].

== Как читать сочетания tmux

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#note(
    "Одновременно",
    [#shortcut[Ctrl][C] — удерживать Ctrl и нажать C.],
    color: blue,
  )],
  [#note(
    "Последовательно",
    [#sequence[Ctrl+B][D] — prefix, отпустить, затем следующая
      клавиша.],
    color: purple,
  )],
)

В tmux #shortcut[Ctrl][B] — prefix: он сообщает tmux, что следующая
клавиша — команда, а не ввод в shell.

== Окна tmux

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .55em,
  [#note("Новое окно", [#sequence[Ctrl+B][C]], color: blue)],
  [#note(
    "Навигация",
    [#sequence[Ctrl+B][N] / #sequence[Ctrl+B][P]],
    color: green,
  )],
  [#note("По номеру", [#sequence[Ctrl+B][0…9]], color: purple)],
)

#sequence[Ctrl+B][,] переименовывает текущее окно. Окна полезны для
независимых задач: editor, расчёт, мониторинг.

== tmux: что ещё полезно знать

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#note(
    "Разделить окно",
    [#sequence[Ctrl+B][%] — рядом появится второе окно. Переключение:
      #shortcut[Ctrl+B][стрелки].],
    color: blue,
  )],
  [#note(
    "Прокрутить вывод",
    [Сначала нажмите #key[Ctrl+B], затем клавишу левой квадратной
      скобки; #key[q] — выйти.],
    color: green,
  )],
)

Сначала достаточно освоить одну сессию и несколько окон. Разделение
экрана пригодится позже для расчёта и просмотра лога.

== Практический сценарий tmux

#terminal([
  #cmd[ssh cluster]
  #remote[tmux new -s chemistry]
  #remote[cd \~/calculations/job01]
  #remote([./run.sh], dir: "~/calculations/job01")
  #comment[\# Ctrl+b, затем d — расчёт остаётся в tmux]
  #remote[exit]
])

Позже: #inlinecode[ssh cluster] → #inlinecode[tmux attach -t
  chemistry].

= Редакторы: Nano, Vim, VS Code

== Три разных подхода

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .7em,
  [#diagram(
    "Nano",
    [Просто исправить файл в терминале.],
    color: green,
  )],
  [#diagram(
    "Vim",
    [Работа с текстом без мыши.],
    color: purple,
  )],
  [#diagram(
    "VS Code",
    [Редактор с окнами и работой по SSH.],
    color: blue,
  )],
)

«Лучшего» редактора нет: выбирайте инструмент под задачу и среду.

== Nano: открыть, сохранить, выйти

#terminal([
  #cmd[nano input.inp]
  #output[^O Write Out ^W Where Is ^K Cut Text]
  #output[^X Exit ^U Paste Text]
])

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .7em,
  [#note("Сохранить", [#shortcut[Ctrl][O]], color: blue)],
  [#note("Выйти", [#shortcut[Ctrl][X]], color: green)],
  [#note("Найти", [#shortcut[Ctrl][W]], color: purple)],
)

== Vim начинается не с клавиш, а с режимов

#grid(
  columns: (1fr, .35fr, 1fr),
  align: center + horizon,
  [#diagram("NORMAL", [движение и команды], color: blue)],
  [#text(size: 1.15em)[— i →]],
  [#diagram("INSERT", [ввод текста], color: green)],
)
Esc возвращает в обычный режим. #inlinecode[v] выделяет текст,
#inlinecode[:] открывает строку команд.

Главное в Vim — понимать, *в каком режиме вы сейчас находитесь*.

== Vim: открыть → изменить → сохранить

#terminal([
  #cmd[vim file.txt]
  #output[i \# перейти в INSERT]
  #output[текст...]
  #output[Esc \# вернуться в NORMAL]
  #output[:w \# сохранить]
  #output[:q \# выйти; :wq — сохранить и выйти; :q! — выйти без
    сохранения]
])

== Vim: навигация и редактирование

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Движение в NORMAL*

    #inlinecode[h j k l] — влево / вниз / вверх / вправо\
    #inlinecode[w] / #inlinecode[b] — слово вперёд / назад\
    #inlinecode[0] / #inlinecode[\$] — начало / конец строки\
    #inlinecode[gg] / #inlinecode[G] — начало / конец файла
  ],
  [
    *Изменение*

    #inlinecode[i] / #inlinecode[a] / #inlinecode[o] — вставка\
    #inlinecode[dd] — удалить строку; #inlinecode[yy] — копировать\
    #inlinecode[p] — вставить; #inlinecode[u] / #inlinecode[Ctrl+r] —
    undo / redo\
    #inlinecode[x] — удалить символ
  ],
)

== Vim: короткие команды складываются в действия

#terminal([
  #output[d — удалить]
  #output[w — следующее слово]
  #output[dw — удалить слово]
  #output[cw — заменить слово]
])

Вместо заучивания сотен сочетаний полезно видеть логику: первая
клавиша задаёт действие, следующая — к чему оно относится.

== Vim: поиск и выделение

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#note(
    "Поиск и замена",
    [#inlinecode[/text] — искать; #inlinecode[n] / #inlinecode[N] —
      следующее / предыдущее; #inlinecode[:%s/old/new/g] — заменить во
      всём файле.],
    color: blue,
  )],
  [#note(
    "Выделение",
    [#inlinecode[v] — посимвольное, #inlinecode[V] — построчное. Затем
      #inlinecode[y] копирует, #inlinecode[d] удаляет.],
    color: green,
  )],
)

== VS Code: редактор с графическим интерфейсом

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #shortcut[Ctrl][P] — открыть файл\
    #key[Ctrl] + #key[Shift] + #key[P] — палитра команд\
    #key[Ctrl] + #key[Shift] + #key[F] — поиск по проекту\
    #shortcut[Ctrl][grave] — встроенный терминал
  ],
  [
    #shortcut[Ctrl][B] — боковая панель\
    #shortcut[Ctrl][Space] — подсказки\
    #key[F2] — переименовать символ\
    #shortcut[Ctrl][S] — сохранить
  ],
)

На macOS часто заменяют Ctrl на Cmd; сверяйтесь с настройками
keybindings.

== VS Code Remote SSH

#grid(
  columns: (1fr, .4fr, 1fr),
  align: center + horizon,
  [#diagram("VS Code", [на ноутбуке], color: blue)],
  [#text(size: 1.2em)[→ SSH →]],
  [#diagram("Файлы и процессы", [на сервере], color: green)],
)

Расширение *Remote — SSH* берёт адрес из #inlinecode[\~/.ssh/config].
В палитре команд выберите `Remote-SSH: Connect to Host...` →
`cluster`. Окно VS Code останется на ноутбуке, а файлы откроются с
сервера.

= Git: история и совместная работа

== Что такое Git

Git — распределённая система контроля версий. Она сохраняет историю
проекта, показывает изменения, позволяет экспериментировать в ветках и
обмениваться работой.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [*Подходит*\ код, input files, скрипты, README, конфигурация],
  [*Не заменяет*\ резервное копирование больших бинарных результатов],
)

== Git ≠ GitHub

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [#diagram(
    "Git",
    [технология и программа контроля версий],
    color: blue,
  )],
  [#diagram(
    "GitHub",
    [один из сервисов для Git-репозиториев и совместной работы],
    color: purple,
  )],
)

Есть и другие сервисы: GitLab, Gitea, университетский сервер; Git
может работать полностью локально.

== Три зоны Git

#grid(
  columns: (1fr, .5fr, 1fr, .6fr, 1fr),
  align: center + horizon,
  [#diagram("Working tree", [ваши файлы], color: blue)],
  [#align(center)[add →]],
  [#diagram("Staging area", [выбранные изменения], color: orange)],
  [#align(center)[commit →]],
  [#diagram("Repository", [локальная история], color: green)],
)

#inlinecode[git add] выбирает изменения, #inlinecode[git commit]
сохраняет их в истории. Так можно собрать один осмысленный commit.

== Создать репозиторий и посмотреть статус

#terminal([
  #cmd([mkdir project], dir: "~")
  #cmd([cd project], dir: "~")
  #cmd[git init -b main]
  #output[Initialized empty Git repository]
  #cmd[git status]
  #output[On branch main]
  #output[No commits yet]
])

#inlinecode[git status] — полезная привычка: запускайте её до и после
действий. #inlinecode[git init -b main] явно задаёт имя первой ветки.

== Первый commit

#terminal([
  #cmd[printf 'print(42)\\n' > main.py]
  #cmd[git status]
  #output[Untracked files: main.py]
  #cmd[git add main.py]
  #cmd[git status]
  #output[Changes to be committed: new file: main.py]
  #cmd[git commit -m "Add initial script"]
])

Commit — небольшая завершённая мысль с понятным сообщением, а не
случайный снимок всего каталога.

== git diff: увидеть изменения до commit

#terminal([
  #cmd[printf 'print(43)\\n' > main.py]
  #cmd[git diff]
  #output[\@\@ \-1 +1 \@\@]
  #error[-print(42)]
  #success[+print(43)]
  #cmd[git diff \-\-staged]
  #comment[\# нет вывода: изменение ещё не добавлено через git add]
  #cmd[git restore main.py]
])

#inlinecode[git diff] показывает правки в файле. #inlinecode[git diff
  \-\-staged] показывает изменения после #inlinecode[git add].
#inlinecode[git restore] отменяет пробное изменение перед следующим
шагом.

== История Git

#terminal([
  #cmd[git log \-\-oneline \-\-graph \-\-decorate \-\-all]
  #output[\* a1d7e0c (HEAD -> main) Add initial script]
])

История — это не только архив: она помогает найти источник изменения и
вернуться к рабочей версии.

== Ветки: отдельная линия работы

#tree[`A  main
    \
     B  experiment`]

#terminal([
  #cmd[git switch -c experiment]
  #cmd[printf 'print(43)\\n' > main.py]
  #cmd[git add main.py]
  #cmd[git commit -m "Try new value"]
])

Современная команда #inlinecode[git switch] яснее для переходов между
ветками. #inlinecode[git checkout] часто встретится в старых
инструкциях.

== Merge: соединяем работу

#terminal([
  #cmd[git switch main]
  #cmd[git merge experiment]
])

#tree[`до:    A  main
            \
             B  experiment

после:  A ── B  main`]

Иногда Git делает fast-forward, иногда создаёт merge commit. Важнее
понимать намерение: переносим проверенную работу из experiment в main.

== Merge conflict — это вопрос к человеку

#terminal([
  #error[<<<<<<< HEAD]
  #output[temperature = 300]
  #error[=======]
  #output[temperature = 350]
  #error[>>>>>>> experiment]
])

+ Выберите нужное содержимое и удалите строки с маркерами конфликта.
+ Запишите решение: #inlinecode[git add file].
+ Завершите слияние: #inlinecode[git commit].

Git не может угадать правильный вариант за вас.

== Remote: локальная и удалённая история

#grid(
  columns: (1fr, .4fr, 1fr),
  align: center + horizon,
  [#diagram(
    "Local repository",
    [commits на вашей машине],
    color: blue,
  )],
  [#align(center)[push →]],
  [#diagram(
    "Remote repository",
    [GitHub / GitLab / server],
    color: green,
  )],
)

#terminal([
  #cmd[git remote -v]
  #comment[\# пока вывода нет: удалённый репозиторий не настроен]
  #cmd[git remote add origin git\@github.com:u/p.git]
  #cmd[git push -u origin main]
])

В примере #inlinecode[git\@github.com:u/p.git] — адрес вашего
репозитория: замените его на настоящий перед выполнением команды.

== clone, fetch, pull, push

#terminal([
  #cmd([git clone git\@github.com:u/p.git demo], dir: "~")
  #cmd([cd demo], dir: "~")
  #cmd([git fetch], dir: "~/demo")
  #comment[\# скачать новую историю, не меняя working tree]
  #cmd([git pull], dir: "~/demo")
  #comment[\# fetch + интеграция изменений]
  #cmd([git push], dir: "~/demo")
])

SSH-адрес в #inlinecode[git clone] использует те же SSH keys, что и
вход на сервер.

== .gitignore: что не должно попадать в историю

#terminal([
  #output[.venv/]
  #output[\_\_pycache\_\_/]
  #output[\*.pyc]
  #output[results/]
  #output[output.log]
  #output[large_trajectory.dump]
])

`.gitignore` не удаляет файл, если он уже tracked. Тогда сначала
убирают его из индекса осознанной командой #inlinecode[git rm
  \-\-cached file].

== Git-гигиена для научного проекта

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Не коммитить*

    - private SSH keys, пароли, API tokens, `.env` с секретами;
    - виртуальное окружение и build artifacts;
    - огромные trajectories без ясной причины.
  ],
  [
    *Обычно коммитить*

    - input files, scripts, analysis code;
    - README, конфигурацию, зависимости;
    - маленькие тестовые данные.
  ],
)

Для больших данных нужны отдельное хранилище, архив или Git LFS при
необходимости.

== Структура научного Git-проекта

#tree(
  `lammps_rutin_mg/
├── runs/
│   ├── ferrum_solvation/          # Папка расчёта, со всеми зависимостями
│   │   └── in.properties.lmp      # Скрипт для запуска LAMMPS-расчёта
│   └── run_properties.sh          # Скрипт для запуска серии расчётов
├── analysis/
│   └── ferrum_solvation/          # Папка с анализом результатов расчёта
│       ├── solvation.typ
│       └── analyze.py
├── literature/                    # Папка с литературным обзором по расчёту
│   └── main.typ
├── README.md                      # Файл-описание дирекории
└── .gitignore`,
  width: 35em,
)

#inlinecode[runs/] — расчёты, #inlinecode[analysis/] — обработка,
#inlinecode[literature/] — текст работы.

== Практический Git-цикл

#terminal([
  #cmd[git pull]
  #cmd[git status]
  #comment[\# работа]
  #cmd[git diff]
  #cmd[git add analysis.py]
  #cmd[git commit -m "Add RDF analysis"]
  #cmd[git push]
])

#note(
  "Осторожно с git add .",
  [Команда удобна, но сначала посмотрите #inlinecode[git status] и
    #inlinecode[git diff]: в staging area не должны случайно попасть
    результаты, секреты или чужие файлы.],
  color: orange,
)

= Один связный workflow

== От ноутбука к расчёту и обратно

#terminal([
  #cmd[ssh chemistry]
  #remote(
    [git clone git\@github.com:group/project.git],
    host: "server",
  )
  #remote([cd project], host: "server")
  #remote([tmux new -s calc], host: "server", dir: "~/project")
  #remote(
    [vim input/calculation.inp],
    host: "server",
    dir: "~/project",
  )
  #remote([bash run.sh], host: "server", dir: "~/project")
  #comment[\# Ctrl+b, затем d — расчёт остаётся на сервере]
  #remote([exit], host: "server", dir: "~/project")
])

== Проверяем результат и сохраняем историю

#terminal([
  #cmd[ssh chemistry]
  #remote([tmux attach -t calc], host: "server")
  #comment[\# расчёт завершился; Ctrl+b, затем d — вернуться в shell]
  #remote([cd project], host: "server")
  #remote([tail -n 20 output.log], host: "server", dir: "~/project")
  #comment[\# после редактирования scripts/analysis.py]
  #remote([git status], host: "server", dir: "~/project")
  #remote([git diff], host: "server", dir: "~/project")
  #remote(
    [git add scripts/analysis.py],
    host: "server",
    dir: "~/project",
  )
  #remote(
    [git commit -m "Improve analysis"],
    host: "server",
    dir: "~/project",
  )
  #remote([git push], host: "server", dir: "~/project")
])

VS Code Remote SSH может заменить Vim для редактирования, но базовая
модель остаётся той же: файлы и процессы находятся на сервере.

== Шпаргалка: Linux и SSH

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Linux*

    #inlinecode[pwd] · #inlinecode[ls] · #inlinecode[cd]\
    #inlinecode[mkdir] · #inlinecode[cp] · #inlinecode[mv]\
    #inlinecode[less] · #inlinecode[grep] · #inlinecode[find]\
    #inlinecode[ps] · #inlinecode[tail -f]
  ],
  [
    *SSH*

    #inlinecode[ssh host]\
    #inlinecode[ssh-keygen -t ed25519]\
    #inlinecode[ssh-copy-id user\@host]\
    #inlinecode[scp] · #inlinecode[rsync -avP]\
    #inlinecode[ssh -L 8888:localhost:8888 host]
  ],
)

== Шпаргалка: tmux, Vim и Git

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: .65em,
  [
    *tmux*

    #inlinecode[new -s name]\
    #inlinecode[attach -t name]\
    #sequence[Ctrl+B][D]\
    #sequence[Ctrl+B][C]\
    #sequence[Ctrl+B][%]
  ],
  [
    *Vim*

    #inlinecode[i] · #inlinecode[Esc]\
    #inlinecode[:w] · #inlinecode[:q!]\
    #inlinecode[dd] · #inlinecode[yy] · #inlinecode[p]\
    #inlinecode[/text] · #inlinecode[n]
  ],
  [
    *Git*

    #inlinecode[status] · #inlinecode[diff]\
    #inlinecode[add] · #inlinecode[commit]\
    #inlinecode[log] · #inlinecode[switch]\
    #inlinecode[pull] · #inlinecode[push]
  ],
)

== Минимальный рабочий набор

#v(1em)
#grid(
  columns: (1fr, .18fr, 1fr, .18fr, 1fr, .18fr, 1fr, .18fr, 1fr),
  align: center,
  [#align(center)[Linux shell]],
  [→],
  [#align(center)[SSH]],
  [→],
  [#align(center)[tmux]],
  [→],
  [#align(center)[Редактор]],
  [→],
  [#align(center)[Git]],
)

#v(1em)
#align(center)[Этого набора достаточно, чтобы спокойно работать на
  Linux-сервере.]
