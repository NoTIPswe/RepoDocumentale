import re
import logging
from pathlib import Path
from dataclasses import dataclass
from typing import List

import pdfplumber

@dataclass(frozen=True)
class GulpeaseResult: 
    pdf_path: Path
    index: float
    words: int
    sentences: int 
    letters: int 

def calculate_for_pdf(pdf_path: Path) -> GulpeaseResult: 
    text = _extract_text(pdf_path)
    letters = _count_letters(text)
    words = _count_words(text)
    sentences = _count_sentences(text)

    if words == 0:
        logging.warning(f"No words found in '{pdf_path}'. Gulpease set to 0.")
        return GulpeaseResult(pdf_path=pdf_path, index=0.0, words=0, sentences=0, letters=0)

    index = 89 + (300 * sentences - 10 * letters) / words

    return GulpeaseResult(
        pdf_path=pdf_path, 
        index=index,
        words=words,
        sentences=sentences,
        letters=letters
    )

def calculate_for_dir(pdf_dir: Path) -> List[GulpeaseResult]: 
    pdfs = sorted(pdf_dir.rglob("*.pdf"))

    if not pdfs: 
        logging.warning(f"No PDFs in '{pdf_dir}'.")
        return []
    
    results: List[GulpeaseResult] = []

    for pdf in pdfs: 
        try: 
            results.append(calculate_for_pdf(pdf))
        except Exception as e:
            logging.error(f"Failed to process '{pdf}': {e}")

    return results


def _extract_text(pdf_path: Path) -> str: 
    text_parts: List[str] = []
    with pdfplumber.open(pdf_path) as pdf: 
        for page in pdf.pages: 
            # Add some tolerance while extracting words
            page_text = page.extract_text(x_tolerance=1)
            if page_text:
                text_parts.append(page_text)
    return "\n".join(text_parts)

def _count_letters(text: str) -> int: 
    return sum(1 for c in text if c.isalpha())

def _count_words(text: str) -> int: 
    return len(text.split())

def _count_sentences(text: str) -> int: 
    sentences = re.split(r"[.!?]+", text)
    return sum(1 for s in sentences if s.strip())