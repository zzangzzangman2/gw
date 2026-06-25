# MainInterface XXTEA 정적 배열 추적

## 요약

- DecryptByteArray magic: `0C 07 08 0D 0B 09`
- `SoketKey`: metadata offset `0x582889`, bytes `66 78 16 18 58 06 77 58`
- `ass`: metadata offset `0x582B67`, 64 bytes recovered
- `XXTEAUtil..cctor` initializes `SoketKey` at static field offset `0x0` and `ass` at `0x8`.

## 회수한 필드

| 필드 | Static offset | 길이 | cctor slot | Usage table | Runtime handle | Metadata offset | Bytes |
|---|---:|---:|---:|---:|---:|---:|---|
| SoketKey | `0x0` | 8 | `0x303A278` | `0x3103F30` | `0x8000000B` | `0x582889` | `66 78 16 18 58 06 77 58` |
| ass | `0x8` | 64 | `0x2FE9CB0` | `0x3103F80` | `0x8000001F` | `0x582B67` | `24 FA 49 9B 10 8D 62 59 29 26 81 67 4B F7 91 EB 36 1F 78 07 49 CA 35 A2 37 D7 B0 A6 49 D3 31 D5 9A 5B 46 86 14 FF 21 CB BC 63 BA 1C 49 FC 94 2F F8 35 D9 46 1F 15 2B 2F 37 54 9D CC 44 D9 77 C4` |

## 복원 영향

- `0C 07 08 0D 0B 09`로 시작하는 파일은 native `DecryptByteArray` 암호화 branch를 탄다.
- 현재 MainInterface xLua TextAsset은 `A-EV` 또는 `K7HT`로 시작하므로 이 magic branch에 직접 들어가지 않는다.
- 회수한 배열은 직접 decode 실험 재현과, 나중에 magic branch를 쓰는 asset을 만났을 때 필요하다.
