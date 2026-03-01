
/srv/docker/backup$ 

dbダンプ
docker exec redmine-db-1 pg_dump -U redmine -Fc redmine > redmine.dump

filesの圧縮
docker run --rm -v /srv/docker/redmine/files:/from -v $(pwd):/bp alpine tar czf /bp/redmine_files.tar.gz -C from .

dbリストア
docker exec -i redmine-test-db_test-1 pg_restore -U redmine_test -d redmine_test --clean --if-exists --no-owner --no-privileges < redmine.dump 

files復元
docker run --rm -v /srv/docker/redmine_test/files:/to -v $(pwd):/bp alpine sh -c "cd /to && tar xzf /bp/redmine_files.tar.gz"

