class Read {
  int bookId;
  bool complete;
  Read({
    this.bookId,
    this.complete,
  });
  factory Read.fromJson(Map<String, dynamic> json) => new Read(
        bookId: json["bookId"],
        complete: json["complete"] == 1,
      );
  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "complete": complete,
      };
}
