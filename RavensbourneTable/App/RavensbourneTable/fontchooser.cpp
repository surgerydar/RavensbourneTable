#include <QPainter>
#include <QRect>
#include <QFontMetrics>
#include <QFontDatabase>
#include <QDebug>
#include <vector>
#include <cmath>

#include "fontchooser.h"

static void listFonts() {
    QFontDatabase database;
    foreach (const QString &family, database.families()) {
        qDebug() << family;
        foreach (const QString &style, database.styles(family)) {
            qDebug() << ">> " << style;
        }
    }
}

FontChooser::FontChooser(QQuickItem *parent) :
    CircularMenu(parent),
    m_fontSizeSelector(0.,90.,16.,72.),
    m_colourSelector(95.,90.),
    m_boldSelector(190.,30.,"b",true),
    m_italicSelector(220.,30.,"i",true),
    m_underlineSelector(250.,30.,"u",true),
    m_sansSelector(285.,30.,"H",true),
    m_serifSelector(315.,30.,"T",true),
    m_familyGroup( 285., 60.) {
    //
    //
    //
    //listFonts();
    m_fontSizeSelector.setFont(QFont());
    m_fontSizeSelector.setSize(32.);
    QFont boldFont;
    boldFont.setPixelSize(32.);
    boldFont.setBold(true);
    m_boldSelector.setFont(boldFont);
    QFont italicFont;
    italicFont.setPixelSize(32.);
    italicFont.setItalic(true);
    m_italicSelector.setFont(italicFont);
    QFont underlineFont;
    underlineFont.setPixelSize(32.);
    underlineFont.setUnderline(true);
    m_underlineSelector.setFont(underlineFont);
    QFont sansFont;
    sansFont.setStyleHint(QFont::SansSerif);
    sansFont.setFamily("Helvetica");
    sansFont.setPixelSize(32.);
    m_sansSelector.setFont(sansFont);
    m_sansSelector.setChecked();
    QFont serifFont;
    serifFont.setStyleHint(QFont::Serif);
    serifFont.setFamily("Times");
    serifFont.setPixelSize(32.);
    m_serifSelector.setFont(serifFont);
    /*
    QFont cursiveFont;
    cursiveFont.setFamily("OldEnglish");
    cursiveFont.setPixelSize(32.);
    m_cursiveSelector.setFont(cursiveFont);
    */
    //
    //
    //
    addControl("size",&m_fontSizeSelector);
    addControl("colour",&m_colourSelector);
    addControl("bold",&m_boldSelector);
    addControl("italic",&m_italicSelector);
    addControl("underline",&m_underlineSelector);
    addControl("family",&m_familyGroup);
    m_familyGroup.addButton("Helvetica",&m_sansSelector);
    m_familyGroup.addButton("Times",&m_serifSelector);
    //
    //
    //
    m_font.setStyleHint(QFont::SansSerif);
    m_font.setFamily("Helvetica");
    m_font.setPixelSize(32);
}

void FontChooser::paint(QPainter *painter) {
    painter->setRenderHint(QPainter::Antialiasing);
    //
    //
    //
    CircularMenu::paint(painter);
    //
    // draw swatch
    //
    painter->save();
    QPointF cp(width()/2.,height()/2.);
    painter->setFont(m_font);
    painter->setPen(m_colour);
    QFontMetricsF metrics = painter->fontMetrics();
    QRectF textBounds = metrics.tightBoundingRect("Aa");
    painter->drawText(cp.x()-textBounds.width()/2.,cp.y()+textBounds.height()/2.,"Aa");
    //
    // draw outline
    //
    QBrush brush("#00D2C2");
    QPen pen(brush,4);
    painter->setPen(pen);
    painter->setBrush(Qt::NoBrush);
    qreal innerRadius = ( m_innerPath.boundingRect().width() / 2. ) - 2;
    qreal outerRadius = ( m_outerPath.boundingRect().width() / 2. ) - 2;
    painter->drawEllipse(cp,outerRadius,outerRadius);
    painter->drawEllipse(cp,innerRadius,innerRadius);
    painter->restore();
}
//
//
//
void FontChooser::mousePressEvent(QMouseEvent *event) {
    QString control = mousePressControls(event);
    if ( control.length() > 0 ) {
        updateFont();
    } else {
        event->ignore();
    }
}

void FontChooser::mouseMoveEvent(QMouseEvent *event) {
    QString control = mouseMoveControls(event);
    if ( control.length() > 0 ) {
        updateFont();
    } else {
        event->ignore();
    }
}

void FontChooser::mouseReleaseEvent(QMouseEvent *event) {
    QString control = mouseReleaseControls(event);
    if ( control.length() > 0 ) {
        updateFont();
    } else {
        event->ignore();
    }
}
void FontChooser::setFont(QFont font, QColor colour) {
    if ( font != m_font || colour != m_colour ) {
        m_font = font;
        m_fontSizeSelector.setSize(m_font.pixelSize());
        m_boldSelector.setChecked(m_font.bold());
        m_italicSelector.setChecked(m_font.italic());
        m_underlineSelector.setChecked(m_font.underline());
        m_colour = colour;
        m_colourSelector.setColour(colour);
        update();
    }
}
//
//
//
void FontChooser::updateFont() {
    QColor oldColour = m_colour;
    QFont oldFont = m_font;
    m_colour = m_colourSelector.getColour();
    QString family = m_familyGroup.selectedButton();
    m_font.setStyleHint(family=="Times" ? QFont::Serif : QFont::SansSerif);
    m_font.setFamily(family);
    m_font.setPixelSize(m_fontSizeSelector.getSize());
    m_font.setBold(m_boldSelector.isChecked());
    m_font.setItalic(m_italicSelector.isChecked());
    m_font.setUnderline(m_underlineSelector.isChecked());
    if ( m_colour != oldColour || m_font != oldFont ) {
        update();
        emit fontChanged(m_font,m_colour);
    }
}
/*
 * ".SF NS Text"
>>  "Regular"
>>  "Bold"
"Al Bayan"
>>  "Plain"
>>  "Bold"
"Al Nile"
>>  "Regular"
>>  "Bold"
"Al Tarikh"
>>  "Regular"
"American Typewriter"
>>  "Regular"
>>  "Light"
>>  "Semibold"
>>  "Bold"
>>  "Condensed"
>>  "Condensed Light"
>>  "Condensed Bold"
"Andale Mono"
>>  "Regular"
"Apple Braille"
>>  "Outline 6 Dot"
>>  "Outline 8 Dot"
>>  "Pinpoint 6 Dot"
>>  "Pinpoint 8 Dot"
>>  "Regular"
"Apple Chancery"
>>  "Chancery"
"Apple Color Emoji"
>>  "Regular"
"Apple SD Gothic Neo"
>>  "Regular"
>>  "Thin"
>>  "UltraLight"
>>  "Light"
>>  "Medium"
>>  "SemiBold"
>>  "Bold"
>>  "ExtraBold"
>>  "Heavy"
"Apple Symbols"
>>  "Regular"
"AppleGothic"
>>  "Regular"
"AppleMyungjo"
>>  "Regular"
"Arial"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Arial Black"
>>  "Regular"
"Arial Hebrew"
>>  "Regular"
>>  "Light"
>>  "Bold"
"Arial Hebrew Scholar"
>>  "Regular"
>>  "Light"
>>  "Bold"
"Arial Narrow"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Arial Rounded MT Bold"
>>  "Regular"
"Arial Unicode MS"
>>  "Regular"
"Athelas"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Avenir"
>>  "Book"
>>  "Roman"
>>  "Book Oblique"
>>  "Oblique"
>>  "Light"
>>  "Light Oblique"
>>  "Medium"
>>  "Medium Oblique"
>>  "Heavy"
>>  "Heavy Oblique"
>>  "Black"
>>  "Black Oblique"
"Avenir Next"
>>  "Regular"
>>  "Italic"
>>  "Ultra Light"
>>  "Ultra Light Italic"
>>  "Medium"
>>  "Medium Italic"
>>  "Demi Bold"
>>  "Demi Bold Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Heavy"
>>  "Heavy Italic"
"Avenir Next Condensed"
>>  "Regular"
>>  "Italic"
>>  "Ultra Light"
>>  "Ultra Light Italic"
>>  "Medium"
>>  "Medium Italic"
>>  "Demi Bold"
>>  "Demi Bold Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Heavy"
>>  "Heavy Italic"
"Ayuthaya"
>>  "Regular"
"Baghdad"
>>  "Regular"
"Bangla MN"
>>  "Regular"
>>  "Bold"
"Bangla Sangam MN"
>>  "Regular"
>>  "Bold"
"Baskerville"
>>  "Regular"
>>  "Italic"
>>  "SemiBold"
>>  "SemiBold Italic"
>>  "Bold"
>>  "Bold Italic"
"Beirut"
>>  "Regular"
"Big Caslon"
>>  "Medium"
"Bodoni 72"
>>  "Book"
>>  "Book Italic"
>>  "Bold"
"Bodoni 72 Oldstyle"
>>  "Book"
>>  "Book Italic"
>>  "Bold"
"Bodoni 72 Smallcaps"
>>  "Book"
"Bodoni Ornaments"
>>  "Regular"
"Bradley Hand"
>>  "Bold"
"Brush Script MT"
>>  "Italic"
"Chalkboard"
>>  "Regular"
>>  "Bold"
"Chalkboard SE"
>>  "Regular"
>>  "Light"
>>  "Bold"
"Chalkduster"
>>  "Regular"
"Charter"
>>  "Roman"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Black"
>>  "Black Italic"
"Cochin"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Comic Sans MS"
>>  "Regular"
>>  "Bold"
"Copperplate"
>>  "Regular"
>>  "Light"
>>  "Bold"
"Corsiva Hebrew"
>>  "Regular"
>>  "Bold"
"Courier"
>>  "Regular"
>>  "Oblique"
>>  "Bold"
>>  "Bold Oblique"
"Courier New"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Damascus"
>>  "Regular"
>>  "Light"
>>  "Medium"
>>  "Semi Bold"
>>  "Bold"
"DecoType Naskh"
>>  "Regular"
"Devanagari MT"
>>  "Regular"
>>  "Bold"
"Devanagari Sangam MN"
>>  "Regular"
>>  "Bold"
"Didot"
>>  "Regular"
>>  "Italic"
>>  "Bold"
"DIN Alternate"
>>  "Bold"
"DIN Condensed"
>>  "Bold"
"Diwan Kufi"
>>  "Regular"
"Diwan Thuluth"
>>  "Regular"
"Euphemia UCAS"
>>  "Regular"
>>  "Italic"
>>  "Bold"
"Farah"
>>  "Regular"
"Farisi"
>>  "Regular"
"Futura"
>>  "Medium"
>>  "Medium Italic"
>>  "Bold"
>>  "Condensed Medium"
>>  "Condensed ExtraBold"
"GB18030 Bitmap"
>>  "Regular"
"Geeza Pro"
>>  "Regular"
>>  "Bold"
"Geneva"
>>  "Regular"
"Georgia"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Gill Sans"
>>  "Regular"
>>  "Italic"
>>  "Light"
>>  "Light Italic"
>>  "SemiBold"
>>  "SemiBold Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "UltraBold"
"Gujarati MT"
>>  "Regular"
>>  "Bold"
"Gujarati Sangam MN"
>>  "Regular"
>>  "Bold"
"Gurmukhi MN"
>>  "Regular"
>>  "Bold"
"Gurmukhi MT"
>>  "Regular"
"Gurmukhi Sangam MN"
>>  "Regular"
>>  "Bold"
"Heiti SC"
>>  "Light"
>>  "Medium"
"Heiti TC"
>>  "Light"
>>  "Medium"
"Helvetica"
>>  "Regular"
>>  "Oblique"
>>  "Light"
>>  "Light Oblique"
>>  "Bold"
>>  "Bold Oblique"
"Helvetica Neue"
>>  "Regular"
>>  "Italic"
>>  "UltraLight"
>>  "UltraLight Italic"
>>  "Thin"
>>  "Thin Italic"
>>  "Light"
>>  "Light Italic"
>>  "Medium"
>>  "Medium Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Condensed Bold"
>>  "Condensed Black"
"Herculanum"
>>  "Regular"
"Hiragino Kaku Gothic Pro"
>>  "W3"
>>  "W6"
"Hiragino Kaku Gothic ProN"
>>  "W3"
>>  "W6"
"Hiragino Kaku Gothic Std"
>>  "W8"
"Hiragino Kaku Gothic StdN"
>>  "W8"
"Hiragino Maru Gothic Pro"
>>  "W4"
"Hiragino Maru Gothic ProN"
>>  "W4"
"Hiragino Mincho Pro"
>>  "W3"
>>  "W6"
"Hiragino Mincho ProN"
>>  "W3"
>>  "W6"
"Hiragino Sans"
>>  "W0"
>>  "W1"
>>  "W2"
>>  "W3"
>>  "W4"
>>  "W5"
>>  "W6"
>>  "W7"
>>  "W8"
>>  "W9"
"Hiragino Sans GB"
>>  "W3"
>>  "W6"
"Hoefler Text"
>>  "Regular"
>>  "Ornaments"
>>  "Italic"
>>  "Black"
>>  "Black Italic"
"Impact"
>>  "Regular"
"InaiMathi"
>>  "Regular"
"Iowan Old Style"
>>  "Roman"
>>  "Titling"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Black"
>>  "Black Italic"
"ITF Devanagari"
>>  "Book"
>>  "Light"
>>  "Medium"
>>  "Demi"
>>  "Bold"
"ITF Devanagari Marathi"
>>  "Book"
>>  "Light"
>>  "Medium"
>>  "Demi"
>>  "Bold"
"Kailasa"
>>  "Regular"
>>  "Bold"
"Kannada MN"
>>  "Regular"
>>  "Bold"
"Kannada Sangam MN"
>>  "Regular"
>>  "Bold"
"Kefa"
>>  "Regular"
>>  "Bold"
"Khmer MN"
>>  "Regular"
>>  "Bold"
"Khmer Sangam MN"
>>  "Regular"
"Kohinoor Bangla"
>>  "Regular"
>>  "Light"
>>  "Medium"
>>  "Semibold"
>>  "Bold"
"Kohinoor Devanagari"
>>  "Regular"
>>  "Light"
>>  "Medium"
>>  "Semibold"
>>  "Bold"
"Kohinoor Telugu"
>>  "Regular"
>>  "Light"
>>  "Medium"
>>  "Semibold"
>>  "Bold"
"Kokonor"
>>  "Regular"
"Krungthep"
>>  "Regular"
"KufiStandardGK"
>>  "Regular"
"Lao MN"
>>  "Regular"
>>  "Bold"
"Lao Sangam MN"
>>  "Regular"
"Lucida Grande"
>>  "Regular"
>>  "Bold"
"Luminari"
>>  "Regular"
"Malayalam MN"
>>  "Regular"
>>  "Bold"
"Malayalam Sangam MN"
>>  "Regular"
>>  "Bold"
"Marion"
>>  "Regular"
>>  "Italic"
>>  "Bold"
"Marker Felt"
>>  "Thin"
>>  "Wide"
"Menlo"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Microsoft Sans Serif"
>>  "Regular"
"Mishafi"
>>  "Regular"
"Mishafi Gold"
>>  "Regular"
"Monaco"
>>  "Regular"
"Mshtakan"
>>  "Regular"
>>  "Oblique"
>>  "Bold"
>>  "BoldOblique"
"Muna"
>>  "Regular"
>>  "Bold"
>>  "Black"
"Myanmar MN"
>>  "Regular"
>>  "Bold"
"Myanmar Sangam MN"
>>  "Regular"
>>  "Bold"
"Nadeem"
>>  "Regular"
"New Peninim MT"
>>  "Regular"
>>  "Inclined"
>>  "Bold"
>>  "Bold Inclined"
"Noteworthy"
>>  "Light"
>>  "Bold"
"Optima"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "ExtraBlack"
"Oriya MN"
>>  "Regular"
>>  "Bold"
"Oriya Sangam MN"
>>  "Regular"
>>  "Bold"
"Palatino"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Papyrus"
>>  "Regular"
>>  "Condensed"
"Phosphate"
>>  "Inline"
>>  "Solid"
"PingFang HK"
>>  "Regular"
>>  "Ultralight"
>>  "Thin"
>>  "Light"
>>  "Medium"
>>  "Semibold"
"PingFang SC"
>>  "Regular"
>>  "Ultralight"
>>  "Thin"
>>  "Light"
>>  "Medium"
>>  "Semibold"
"PingFang TC"
>>  "Regular"
>>  "Ultralight"
>>  "Thin"
>>  "Light"
>>  "Medium"
>>  "Semibold"
"Plantagenet Cherokee"
>>  "Regular"
"PT Mono"
>>  "Regular"
>>  "Bold"
"PT Sans"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"PT Sans Caption"
>>  "Regular"
>>  "Bold"
"PT Sans Narrow"
>>  "Regular"
>>  "Bold"
"PT Serif"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"PT Serif Caption"
>>  "Regular"
>>  "Italic"
"Raanana"
>>  "Regular"
>>  "Bold"
"Sana"
>>  "Regular"
"Sathu"
>>  "Regular"
"Savoye LET"
>>  "Plain"
"Seravek"
>>  "Regular"
>>  "Italic"
>>  "ExtraLight"
>>  "ExtraLight Italic"
>>  "Light"
>>  "Light Italic"
>>  "Medium"
>>  "Medium Italic"
>>  "Bold"
>>  "Bold Italic"
"Shree Devanagari 714"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"SignPainter"
>>  "HouseScript"
>>  "HouseScript Semibold"
"Silom"
>>  "Regular"
"Sinhala MN"
>>  "Regular"
>>  "Bold"
"Sinhala Sangam MN"
>>  "Regular"
>>  "Bold"
"Skia"
>>  "Regular"
>>  "Light"
>>  "Bold"
>>  "Black"
>>  "Extended"
>>  "Light Extended"
>>  "Black Extended"
>>  "Condensed"
>>  "Light Condensed"
>>  "Black Condensed"
"Snell Roundhand"
>>  "Regular"
>>  "Bold"
>>  "Black"
"Songti SC"
>>  "Regular"
>>  "Light"
>>  "Bold"
>>  "Black"
"Songti TC"
>>  "Regular"
>>  "Light"
>>  "Bold"
"STIXGeneral"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"STIXIntegralsD"
>>  "Regular"
>>  "Bold"
"STIXIntegralsSm"
>>  "Regular"
>>  "Bold"
"STIXIntegralsUp"
>>  "Regular"
>>  "Bold"
"STIXIntegralsUpD"
>>  "Regular"
>>  "Bold"
"STIXIntegralsUpSm"
>>  "Regular"
>>  "Bold"
"STIXNonUnicode"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"STIXSizeFiveSym"
>>  "Regular"
"STIXSizeFourSym"
>>  "Regular"
>>  "Bold"
"STIXSizeOneSym"
>>  "Regular"
>>  "Bold"
"STIXSizeThreeSym"
>>  "Regular"
>>  "Bold"
"STIXSizeTwoSym"
>>  "Regular"
>>  "Bold"
"STIXVariants"
>>  "Regular"
>>  "Bold"
"STSong"
>>  "Regular"
"Sukhumvit Set"
>>  "Text"
>>  "Light"
>>  "Medium"
>>  "Semi Bold"
>>  "Bold"
>>  "Thin"
"Superclarendon"
>>  "Regular"
>>  "Italic"
>>  "Light"
>>  "Light Italic"
>>  "Bold"
>>  "Bold Italic"
>>  "Black"
>>  "Black Italic"
"Symbol"
>>  "Regular"
"Tahoma"
>>  "Normal"
>>  "Negreta"
"Tamil MN"
>>  "Regular"
>>  "Bold"
"Tamil Sangam MN"
>>  "Regular"
>>  "Bold"
"Telugu MN"
>>  "Regular"
>>  "Bold"
"Telugu Sangam MN"
>>  "Regular"
>>  "Bold"
"Thonburi"
>>  "Regular"
>>  "Light"
>>  "Bold"
"Times"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Times New Roman"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Trattatello"
>>  "Regular"
"Trebuchet MS"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Verdana"
>>  "Regular"
>>  "Italic"
>>  "Bold"
>>  "Bold Italic"
"Waseem"
>>  "Regular"
>>  "Light"
"Webdings"
>>  "Regular"
"Wingdings"
>>  "Regular"
"Wingdings 2"
>>  "Regular"
"Wingdings 3"
>>  "Regular"
"Zapf Dingbats"
>>  "Regular"
"Zapfino"
>>  "Regular"
*/
