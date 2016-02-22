import webbrowser


class Movie():

    """The Movie class.
    Has general details about movies such as it's title short synopsis,
    it's poster image, and trailer video URL to name a few.
    """

    # A list of ratings that can be applied to the movie
    VALID_RATINGS = ["G", "PG", "PG-13", "R", "NR"]


    def __init__(self, movie_title, movie_storyline,
                 poster_image, trailer_youtube, movie_rating="NR"):

        self.title = movie_title
        self.storyline = movie_storyline
        self.poster_image_url = poster_image
        self.trailer_youtube_url = trailer_youtube
        self.rating = movie_rating


    def show_trailer(self):
        webbrowser.open(self.trailer_youtube_url)


    def rating_image_location(self):
        """Based on the rating of the movie give the location of the
           representative image file on the server.
        """
        if self.rating in self.VALID_RATINGS:
            return './img/' + self.rating + '-rating.PNG'
        else:
            return './img/nr-rating.PNG'


    def get_casa_rating(self):
        """Checks that the provided rating is indeed known and returns it,
        otherwise it is not rated, or NR.
        """
        if self.rating in self.VALID_RATINGS:
            return self.rating
        else:
            return "NR"
