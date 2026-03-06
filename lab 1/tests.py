from datetime import date

from models import Supplier

test_suppliers = [
    Supplier("Еко-Ферма", "Яблука", date(2026, 5, 10), 25.5, "+38097111", "eco@farm.ua", "img1.jpg"),
    Supplier("Сталь-Пром", "Арматура", date(2026, 6, 15), 18200.0, None, "sales@steel.com", None),
    Supplier("Морепродукти", "Креветки", date(2026, 4, 20), 450.0, "+38048222", "fish@sea.ua", "shrimp.png"),
    Supplier("Айті-Світ", "Ноутбуки", date(2026, 12, 1), 35000.0, "+38044333", "info@itworld.com", "laptop.jpg"),
    Supplier("Олія-Плюс", "Соняшникова олія", date(2026, 3, 25), 62.0, None, None, "oil.jpg"),
    Supplier("Винний Дім", "Вино", date(2026, 9, 30), 310.0, "+38031444", "winery@vine.ua", "wine.jpg")
]

