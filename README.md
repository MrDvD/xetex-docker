# XeLaTeX в Docker

Docker-образы для сборки документов LaTeX с помощью XeLaTeX. Репозиторий
содержит минимальный базовый образ с TeX Live и расширенный образ для
лабораторных работ.

## Образы

- `base` — Ubuntu 22.04 и актуальная версия TeX Live, устанавливаемая
	во время сборки. В базовый набор входят `xetex`, `fontspec` и `geometry`.
- `labs` — образ на основе `ghcr.io/mrdvd/xetex-docker:base-2026`.
	Дополнительно устанавливает `make`, шрифты CMU, русскую локализацию,
	`hyperref`, `listings`, `biblatex`, `biber`, `biblatex-gost` и другие пакеты,
	необходимые для лабораторных работ.

В обоих образах рабочим каталогом является `/data`, а каталог `/data`
объявлен Docker volume.

## Требования

- Docker;
- доступ к интернету во время сборки, так как TeX Live и пакеты скачиваются
	с CTAN;
- для запуска команд ниже используется Linux/macOS или оболочка с аналогичным
	синтаксисом монтирования каталогов.

## Сборка

Из корня репозитория выполните:

```bash
docker build -f docker/Dockerfile.base -t xetex-base:latest docker
docker build -f docker/Dockerfile.labs -t xetex-labs:latest docker
```

`Dockerfile.labs` по умолчанию использует опубликованный базовый образ
`ghcr.io/mrdvd/xetex-base:base-2026`. Если требуется собрать лабораторный
образ на локальном базовом образе, измените строку `FROM` в этом Dockerfile на
`xetex-base:latest`.

## Использование

Смонтируйте каталог с исходниками в `/data` и запустите XeLaTeX:

```bash
docker run --rm \
	-v "$PWD:/data" \
	xetex-labs:latest \
	xelatex -interaction=nonstopmode main.tex
```

Для проектов с Makefile:

```bash
docker run --rm \
	-v "$PWD:/data" \
	xetex-labs:latest \
	make
```

Результаты сборки (`.pdf`, вспомогательные файлы и логи) появятся в исходном
каталоге на хосте, поскольку он смонтирован в `/data`.

## Структура репозитория

```text
.
├── docker/
│   ├── Dockerfile.base   # базовый образ XeLaTeX
│   ├── Dockerfile.labs   # образ для лабораторных работ
│   └── texlive.profile   # профиль установки TeX Live
└── README.md
```
