#!/bin/bash
# ══════════════════════════════════════════════════
# Quran Audio Downloader
# Sheikh Khamisi Sinongo — Madrasat Al-Aliyya
# Downloads: Abdul Basit + Hani Al-Rifai (all 114 surahs)
# ══════════════════════════════════════════════════

echo "🕌 بسم الله الرحمن الرحيم"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 Quran Audio Downloader"
echo "Reciters: Abdul Basit + Hani Al-Rifai"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create folders
mkdir -p audio/abdulbasit
mkdir -p audio/rifai

# Surah names for progress display
SURAHS=(
  "Al-Fatihah" "Al-Baqarah" "Aal-Imran" "An-Nisa" "Al-Maidah"
  "Al-Anam" "Al-Araf" "Al-Anfal" "At-Tawbah" "Yunus"
  "Hud" "Yusuf" "Ar-Rad" "Ibrahim" "Al-Hijr"
  "An-Nahl" "Al-Isra" "Al-Kahf" "Maryam" "Taha"
  "Al-Anbiya" "Al-Hajj" "Al-Muminun" "An-Nur" "Al-Furqan"
  "Ash-Shuara" "An-Naml" "Al-Qasas" "Al-Ankabut" "Ar-Rum"
  "Luqman" "As-Sajdah" "Al-Ahzab" "Saba" "Fatir"
  "Ya-Sin" "As-Saffat" "Sad" "Az-Zumar" "Ghafir"
  "Fussilat" "Ash-Shura" "Az-Zukhruf" "Ad-Dukhan" "Al-Jathiyah"
  "Al-Ahqaf" "Muhammad" "Al-Fath" "Al-Hujurat" "Qaf"
  "Adh-Dhariyat" "At-Tur" "An-Najm" "Al-Qamar" "Ar-Rahman"
  "Al-Waqiah" "Al-Hadid" "Al-Mujadilah" "Al-Hashr" "Al-Mumtahanah"
  "As-Saf" "Al-Jumuah" "Al-Munafiqun" "At-Taghabun" "At-Talaq"
  "At-Tahrim" "Al-Mulk" "Al-Qalam" "Al-Haqqah" "Al-Maarij"
  "Nuh" "Al-Jinn" "Al-Muzzammil" "Al-Muddaththir" "Al-Qiyamah"
  "Al-Insan" "Al-Mursalat" "An-Naba" "An-Naziat" "Abasa"
  "At-Takwir" "Al-Infitar" "Al-Mutaffifin" "Al-Inshiqaq" "Al-Buruj"
  "At-Tariq" "Al-Ala" "Al-Ghashiyah" "Al-Fajr" "Al-Balad"
  "Ash-Shams" "Al-Layl" "Ad-Duha" "Ash-Sharh" "At-Tin"
  "Al-Alaq" "Al-Qadr" "Al-Bayyinah" "Az-Zalzalah" "Al-Adiyat"
  "Al-Qariah" "At-Takathur" "Al-Asr" "Al-Humazah" "Al-Fil"
  "Quraysh" "Al-Maun" "Al-Kawthar" "Al-Kafirun" "An-Nasr"
  "Al-Masad" "Al-Ikhlas" "Al-Falaq" "An-Nas"
)

BASE_BASIT="https://download.quranicaudio.com/quran/abdulbasit_murattal"
BASE_RIFAI="https://download.quranicaudio.com/quran/hani_rifai"

TOTAL=114
DONE=0
FAILED=0

download_surah() {
  local NUM=$(printf "%03d" $1)
  local NAME=${SURAHS[$1-1]}
  local SRC_BASIT="$BASE_BASIT/$NUM.mp3"
  local SRC_RIFAI="$BASE_RIFAI/$NUM.mp3"
  local DEST_BASIT="audio/abdulbasit/$NUM.mp3"
  local DEST_RIFAI="audio/rifai/$NUM.mp3"

  # Abdul Basit
  if [ ! -f "$DEST_BASIT" ]; then
    curl -s -L -o "$DEST_BASIT" "$SRC_BASIT" && \
      echo "  ✅ [$1/114] عبد الباسط — $NAME" || \
      { echo "  ❌ [$1/114] عبد الباسط FAILED — $NAME"; FAILED=$((FAILED+1)); }
  else
    echo "  ⏭  [$1/114] عبد الباسط — $NAME (already exists)"
  fi

  # Hani Al-Rifai
  if [ ! -f "$DEST_RIFAI" ]; then
    curl -s -L -o "$DEST_RIFAI" "$SRC_RIFAI" && \
      echo "  ✅ [$1/114] هاني الرفاعي — $NAME" || \
      { echo "  ❌ [$1/114] هاني الرفاعي FAILED — $NAME"; FAILED=$((FAILED+1)); }
  else
    echo "  ⏭  [$1/114] هاني الرفاعي — $NAME (already exists)"
  fi

  DONE=$((DONE+1))
}

echo ""
echo "📂 Saving to: $(pwd)/audio/"
echo "⏳ Starting download... (this may take 20-40 minutes)"
echo ""

for i in $(seq 1 114); do
  download_surah $i
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Download complete!"
echo "📊 Surahs downloaded: $DONE / $TOTAL"
echo "❌ Failed: $FAILED"
echo ""
du -sh audio/abdulbasit/ 2>/dev/null && echo "📦 Abdul Basit folder size:"
du -sh audio/rifai/ 2>/dev/null && echo "📦 Hani Al-Rifai folder size:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🕌 جزاكم الله خيراً"
