FROM scratch

ENV PORT 8000
EXPOSE $PORT

COPY twitter-stat /
CMD ["/twitter-stat"]