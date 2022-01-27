# Memory
- [Basic Memory Map](#basic-memory-map)
- [Accessing Extended Memory](#accessing-extended-memory)

### Basic Memory Map
The Default Memory Map of the Pix80 is extremely simplistic, simply splitting the RAM and ROM space in half.

```text
 0x0000 - 0x7FFF 0x8000 - 0xFFFF
 _______________________________
|               |               |
|      ROM      |      RAM      |
|_______________|_______________|

```

### Accessing Extended Memory

Extended Memory can be accessed through Device (tba), allowing all the available memory to be swapped out on demand.
Device (tba) is an 8-Bit Register, essentially extending the 16-Bit Address range of the Z80 (64 kilobytes) to 24-Bits (16 megabytes).

```text
One dash represent 64 kilobytes,
the brackets are simply delimiters

Regular amount of Memory:
[-]

Extended Memory (split for clarity):
[--------------------------------]
[--------------------------------]
[--------------------------------]
[--------------------------------]
[--------------------------------]
[--------------------------------]
[--------------------------------]
[--------------------------------]
```

It can simply be set by sending an `OUT` Instruction its way.
Its current value can be read using an `IN` instruction.