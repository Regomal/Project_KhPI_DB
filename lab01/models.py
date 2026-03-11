from dataclasses import dataclass
from datetime import date

@dataclass
class Supplier:

    name: str
    product: str
    nextDelivery: date
    price: float
    phone: str | None
    email: str | None
    photo_path: str | None
    id: int = -1
